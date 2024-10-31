-- local AClib = require("__SchallAutolinkedChest__.lib.AClib")
local cfg1 = require("config.config-1")
local basept = require("lib.base-pt")



local ACpt = {}



function ACpt.AC_name(tier)
  return cfg1.AC_name(tier)
end

function ACpt.AC_item(tier)
  local name = ACpt.AC_name(tier)
  local item = table.deepcopy(basept.chest.item)
  item.name = name
  item.place_result = name
  item.localised_description = {"entity-description.Schall-autolinked-chest"}
  item.flags = nil
  item.subgroup = "storage"
  item.order = "a[items]-l[autolinked-chest]-" .. tier
  item.stack_size = 50
  return item
end

function ACpt.AC_entity(tier)
  local name = ACpt.AC_name(tier)
  -- local enty = table.deepcopy(basept.chest.entity)
  local enty = basept.linked_chest_entity()
  enty.name = name
  enty.minable.result = name
  enty.localised_description = {"entity-description.Schall-autolinked-chest"}
  enty.circuit_wire_connection_point = basept.chest.entity.circuit_wire_connection_point
  enty.circuit_connector_sprites = basept.chest.entity.circuit_connector_sprites
  enty.circuit_wire_max_distance = basept.chest.entity.circuit_wire_max_distance
  enty.gui_mode = "none" -- all, none, admins
  enty.inventory_size = cfg1.AC_inventory_sizes[tier]
  enty.fast_replaceable_group = nil
  return enty
end

function ACpt.AC_recipe(tier)
  local name = ACpt.AC_name(tier)
  return
  {
    type = "recipe",
    name = name,
    ingredients = {{ type="item", name="steel-chest", amount=2 }},
    results = {{ type="item", name=name, amount=1 }},
    -- energy_required = 1,
    enabled = false
  }
end



return ACpt