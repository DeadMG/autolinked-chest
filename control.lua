local AClib = require("lib.AClib")
local cfg2 = require("config.config-2")



local cfgR = {}


local function init_settings()
  cfgR = {
    def_inv_limit = {},
    link_on_built = settings.global[cfg2.mod_prefix.."link-chests-built-enable"].value,
    link_on_hotkey_shortcut = settings.global[cfg2.mod_prefix.."link-chests-hotkey-shortcut-enable"].value,
  }
  for tier = 1, cfg2.tier_max do
    cfgR.def_inv_limit[tier] = settings.global[cfg2.mod_prefix.."autolinked-chest-"..tier.."-default-inventory-limit"].value + 1
  end
  cfgR.set = true
end



local function set_default_inventory_limit(enty, link_id)
  local tier = tonumber(enty.name:match(cfg2.AC_tier_ptrn))
  local limit = cfgR.def_inv_limit[tier]
  if not tier then return end
  local ptsize = enty.prototype.get_inventory_size(defines.inventory.chest)
  if limit >= ptsize then return end
  local inv = enty.force.get_linked_inventory(enty.prototype, link_id)
  if not inv then
    -- Insert and remove item, force initializing the inventory
    enty.insert{name="raw-fish"}
    enty.remove_item{name="raw-fish"}
    inv = enty.force.get_linked_inventory(enty.prototype, link_id)
  end
  inv.set_bar(limit)
end

local function print_link_id(enty, player)
  AClib.create_flying_text_link_id(enty.surface, enty.position, enty.link_id, player)
  AClib.debugprint("Link ID [color=yellow]" .. enty.link_id .. "[/color] (0x[color=yellow]" .. string.format("%X", enty.link_id) .."[/color])")
end

local function randomize_link_id(enty)
  local force = enty.force
  local link_id
  local inv
  for trial = 1, cfg2.rand_trials_max do
    link_id = cfg2.rand_link_id()
    inv = force.get_linked_inventory(enty.prototype, link_id)
    if not inv then
      AClib.debugprint("Link ID [color=green]" .. link_id .. "[/color] (0x[color=green]" .. string.format("%X", link_id) .."[/color]) was not used, now assigned to this chest.")
      enty.link_id = link_id
      set_default_inventory_limit(enty, link_id)
      break
    elseif inv.is_empty() then
      if trial > cfg2.rand_trials_empty then
        AClib.debugprint("Link ID [color=green]" .. link_id .. "[/color] (0x[color=green]" .. string.format("%X", link_id) .."[/color]) is empty (a chance in use).  Now assigned to this chest as the " .. trial .. "-th attempt.")
        enty.link_id = link_id
        set_default_inventory_limit(enty, link_id)
        break
      else
        AClib.debugprint("Link ID [color=red]" .. link_id .. "[/color] (0x[color=red]" .. string.format("%X", link_id) .."[/color]) is empty (a chance in use).  Now retrying...")
      end
    else
      AClib.debugprint("Link ID [color=red]" .. link_id .. "[/color] (0x[color=red]" .. string.format("%X", link_id) .."[/color]) is already used.  Now retrying...")
    end
  end
end

local function cluster_change_link_id(enty, link_id_from, link_id_to)
  local neighbours = enty.surface.find_entities_filtered{ name = enty.name, position = enty.position, radius = cfg2.AC_search_radius }
  for k, v in pairs(neighbours) do
    -- Note that the condition is DIFFERENT from the similar loop in link_chests_on_built()
    if v.link_id == link_id_from then
      v.link_id = link_id_to
      AClib.create_flying_text_linked(v.surface, v.position)
      cluster_change_link_id(v, link_id_from, link_id_to)
    end
  end
end

local function link_chests_on_built(e)
  local entyO = e.entity or e.created_entity
  local player = e.player_index and game.get_player(e.player_index) or entyO.last_user
  local force = entyO.force
  local surface = entyO.surface
  -- Currently can handle the single prototype only
  -- Trying to match the placed prototype only, so no need to process other prototypes anyway
  local found_F = false                 -- Flag to filled (non-empty) inventory found
  local id_F = entyO.link_id            -- Link ID to set in the final phase
  local position_F                      -- Position of filled (non-empty) inventory
  -- Neighbours phase : Check this with neighbouring chests
  local name = entyO.name
  local link_id
  local inv
  local enty
  local neighbours = surface.find_entities_filtered{ name = name, position = entyO.position, radius = cfg2.AC_search_radius }
  -- player.print("Neighbours (+Self) : " .. #neighbours)
  local act_cnt = 0
  for k, enty in pairs(neighbours) do
    if enty ~= entyO and enty.link_id ~= id_F then
      -- Acutal neighbour (Not itself)
      -- surface.create_entity{ name = "flying-text", position = enty.position, text = tostring(k) }
      act_cnt = act_cnt + 1
      link_id = enty.link_id
      inv = force.get_linked_inventory(enty.prototype, link_id)
      if inv and not inv.is_empty() then
        -- Non-empty inventory
        if found_F then
          if id_F ~= enty.link_id then
            -- More then one filled inventories, so abort linking attempt
            AClib.create_flying_text_multiple_link_id(surface, entyO.position, player)
            return
          end
        else
          -- Found the first filled inventory, so set to it
          found_F = true
          id_F = enty.link_id
          position_F = enty.position
        end
      else
        -- Empty inventory
        if not found_F then
          -- If not yet found any non-empty inventories, then just use the smaller link ID
          id_F = math.min(id_F, link_id)
        end
      end
    end
  end
  -- AClib.debugprint("Neighbours Actual : " .. act_cnt)
  -- Assignment phase : Assigning the same link ID to all chests, including their clusters
  local id_C
  for k, enty in pairs(neighbours) do
    if enty.link_id ~= id_F then
      -- Set this chest together with their clusters
      id_C = enty.link_id
      enty.link_id = id_F
      AClib.create_flying_text_linked(surface, enty.position, player)
      cluster_change_link_id(enty, id_C, id_F)
    end
  end
end

local function link_chests_on_selection(e)
  local player = game.get_player(e.player_index)
  local force = player.force
  local surface = e.surface
  -- Currently can handle the single prototype only
  -- Will need more complex code to deal with multi prototypes in the future
  local found_F = false                 -- Flag to filled (non-empty) inventory found
  local id_F = e.entities[1].link_id    -- Link ID to set in the final phase
  local position_F                      -- Position of filled (non-empty) inventory
  -- Scan phase : Check if there are no more than one filled inventory, so all chests are allowed to be linked.
  local link_id
  local inv
  for id, enty in pairs(e.entities) do
    link_id = enty.link_id
    inv = force.get_linked_inventory(enty.prototype, link_id)
    if inv and not inv.is_empty() then
      -- Non-empty inventory
      if found_F then
        if id_F ~= enty.link_id then
          -- More then one filled inventories, so abort linking attempt
          AClib.create_flying_text_multiple_link_id(surface, position_F, player)
          AClib.create_flying_text_multiple_link_id(surface, enty.position, player)
          return
        end
      else
        -- Found the first filled inventory, so set to it
        found_F = true
        id_F = enty.link_id
        position_F = enty.position
      end
    else
      -- Empty inventory
      if not found_F then
        -- If not yet found any non-empty inventories, then just use the smaller link ID
        id_F = math.min(id_F, link_id)
      end
    end
  end
  -- Assignment phase : Assigning the same link ID to all chests
  -- local id_O
  for id, enty in pairs(e.entities) do
    if enty.link_id ~= id_F then
      -- id_O = enty.link_id
      enty.link_id = id_F
      AClib.create_flying_text_linked(surface, enty.position)
      -- force.get_linked_inventory(enty.prototype, id_O).destroy()  -- Recycling the old empty inventory does not work somehow
    end
  end
end

local function check_chests_on_selection(e)
  local player = game.get_player(e.player_index)
  local force = player.force
  local surface = e.surface
  -- Currently can handle the single prototype only
  -- Will need more complex code to deal with multi prototypes in the future
  local found_F = false                 -- Flag to filled (non-empty) inventory found
  local id_F = e.entities[1].link_id    -- Link ID to set in the final phase
  local position_F                      -- Position of filled (non-empty) inventory
  local link_id
  local inv
  -- Scan phase : Check if there are no more than one filled inventory, so all chests are allowed to be linked.
  for id, enty in pairs(e.entities) do
    link_id = enty.link_id
    inv = force.get_linked_inventory(enty.prototype, link_id)
    if inv and not inv.is_empty() then
      -- Non-empty inventory
      if found_F then
        if id_F ~= enty.link_id then
          -- More then one filled inventories, so abort linking attempt
          AClib.create_flying_text_multiple_link_id(surface, position_F, player)
          AClib.create_flying_text_multiple_link_id(surface, enty.position, player)
          return
        end
      else
        -- Found the first filled inventory, so set to it
        found_F = true
        id_F = enty.link_id
        position_F = enty.position
      end
    else
      -- Empty inventory
      if not found_F then
        -- If not yet found any non-empty inventories, then just use the smaller link ID
        id_F = math.min(id_F, link_id)
      end
    end
  end
  player.print({"description."..cfg2.mod_prefix.."message-link-ok"})
end


local function built_entity(e)
  if not cfgR.set then init_settings() end
  local enty = e.entity or e.created_entity
  if not enty or not enty.valid or not enty.name:match(cfg2.AC_ptrn) then return end
  randomize_link_id(enty)
  if cfgR.link_on_built then link_chests_on_built(e) end
end

local function selected_entity_changed(e)
  local player = game.get_player(e.player_index)
  -- local last = e.last_entity
  local selection = player.selected
  -- if selection and selection.valid and selection.name:match(cfg2.AC_ptrn) then
  if selection and selection.valid and selection.type == cfg2.AC_type then
    print_link_id(selection, player)
  end
end

local function player_selected_area(e)
  if not cfgR.set then init_settings() end
  -- local player = game.get_player(e.player_index)
  if e.item == cfg2.AC_sel_tool_name and #e.entities > 1 then
    if cfgR.link_on_hotkey_shortcut then
      link_chests_on_selection(e)
    else
      check_chests_on_selection(e)
    end
  end
end

local function player_alt_selected_area(e)
  -- local player = game.get_player(e.player_index)
  if e.item == cfg2.AC_sel_tool_name and #e.entities > 1 then
    check_chests_on_selection(e)
  end
end

local function runtime_mod_setting_changed(e)
  if not e.setting:find(cfg2.mod_prefix_ptrn) then return end
  init_settings()
end



script.on_event(defines.events.on_runtime_mod_setting_changed,          runtime_mod_setting_changed)
-- script.on_event({defines.events.on_built_entity,
--                  defines.events.on_robot_built_entity,
--                  defines.events.script_raised_built,
--                  defines.events.script_raised_revive},                  built_entity, cfg2.linkedchest_filter)
script.on_event(defines.events.on_built_entity,                         built_entity, cfg2.linkedchest_filter)
script.on_event(defines.events.on_robot_built_entity,                   built_entity, cfg2.linkedchest_filter)
script.on_event(defines.events.script_raised_built,                     built_entity, cfg2.linkedchest_filter)
script.on_event(defines.events.script_raised_revive,                    built_entity, cfg2.linkedchest_filter)
script.on_event(defines.events.on_selected_entity_changed,              selected_entity_changed)
script.on_event(defines.events.on_player_selected_area,                 player_selected_area)
script.on_event(defines.events.on_player_alt_selected_area,             player_alt_selected_area)
