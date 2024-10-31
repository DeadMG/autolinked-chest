local cfg1 = require("config.config-1")

data:extend
{
  {
    -- This allows loading the selection-tool type item when mods are removed
    type = "selection-tool",
    name = cfg1.AC_sel_tool_name,
    -- icon = "__base__/graphics/icons/blueprint.png",
    -- icon_size = 64, icon_mipmaps = 4,
    icons = {
      { icon = "__base__/graphics/icons/upgrade-planner.png", icon_size = 64, icon_mipmaps = 4 },
      { icon = "__base__/graphics/icons/linked-chest-icon.png", icon_size = 64, icon_mipmaps = 4 },
    },
    hidden=true,
    flags = {"not-stackable", "only-in-cursor", "spawnable"},
    subgroup = "other",
    order = "x[info]-l[linked-chest]",
    select = {
        mode = {"buildable-type", "same-force"},
        cursor_box_type = "entity",
        entity_filters = cfg1.AC_name_table(),
        border_color = { r = 0, g = 1, b = 0 },
    },
    alt_select = {
        mode = {"buildable-type", "same-force"},
        cursor_box_type = "entity",
        entity_filters = cfg1.AC_name_table(),
        border_color = { r = 1, g = 0, b = 0 },
    },
    stack_size = 1,
  },
}
