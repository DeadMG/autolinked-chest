local basept = {}



-- This file is about direct copy-and-paste from vanilla code, for later modification by code of this mod.
-- This is done instead of direct table.deepcopy of linked-chest,
-- in order to prevent possible game-breaking conflicts caused by modification from other mods (like removal of sprite layer).
-- Even changes can be non-game-breaking, but can still be unbalanced.  (e.g., modified health, resistances.)

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")



basept.chest = { }

basept.chest.item =
  {
    type = "item",
    name = "linked-chest",
    icon = "__base__/graphics/icons/linked-chest-icon.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"hidden"},
    subgroup = "other",
    order = "a[items]-a[linked-chest]",
    place_result = "linked-chest",
    stack_size = 10
  }

basept.chest.entity =
  {
    type = "container",
    name = "steel-chest",
    icon = "__base__/graphics/icons/steel-chest.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.2, result = "steel-chest"},
    max_health = 350,
    corpse = "steel-chest-remnants",
    dying_explosion = "steel-chest-explosion",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.43 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.43 },
    resistances =
    {
      {
        type = "fire",
        percent = 90
      },
      {
        type = "impact",
        percent = 60
      }
    },
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    damaged_trigger_effect = hit_effects.entity(),
    fast_replaceable_group = "container",
    inventory_size = 48,
    vehicle_impact_sound = sounds.generic_impact,
    picture =
    {
      layers =
      {
        {
          filename = "__base__/graphics/entity/steel-chest/steel-chest.png",
          priority = "extra-high",
          width = 64,
          height = 80,
          shift = util.by_pixel(-0.25, -0.5),
          scale = 0.5
        },
        {
          filename = "__base__/graphics/entity/steel-chest/steel-chest-shadow.png",
          priority = "extra-high",
          width = 110,
          height = 46,
          shift = util.by_pixel(12.25, 8),
          draw_as_shadow = true,
          scale = 0.5
        }
      }
    },
    circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
    circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance
  }

basept.chest.recipe =
  {
    type = "recipe",
    name = "steel-chest",
    enabled = false,
    ingredients = {{"steel-plate", 8}},
    result = "steel-chest"
  }

function basept.linked_chest_entity()
  local linked_chest = util.table.deepcopy(basept.chest.entity)
  -- local linked_chest = util.table.deepcopy(data.raw["container"]["wooden-chest"])
  linked_chest.type = "linked-container"
  linked_chest.name = "linked-chest"
  linked_chest.minable.result = "linked-chest"
  linked_chest.circuit_wire_connection_point = nil
  linked_chest.circuit_connector_sprites = nil
  linked_chest.circuit_wire_max_distance = nil
  linked_chest.gui_mode = "admins" -- all, none, admins
  linked_chest.icon = "__base__/graphics/icons/linked-chest-icon.png"
  linked_chest.picture =
  {
    layers =
    {
      {
        filename = "__base__/graphics/entity/linked-chest/linked-chest.png",
        priority = "extra-high",
        width = 66,
        height = 74,
        frame_count = 7,
        shift = util.by_pixel(0, -2),
        scale = 0.5
      },
      {
        filename = "__base__/graphics/entity/linked-chest/linked-chest-shadow.png",
        priority = "extra-high",
        width = 112,
        height = 46,
        repeat_count = 7,
        shift = util.by_pixel(12, 4.5),
        draw_as_shadow = true,
        scale = 0.5
      }
    }
  }
  return linked_chest
end



return basept