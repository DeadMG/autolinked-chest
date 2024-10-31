local cfg1 = require("config.config-1")



data:extend
{
  {
    type = "shortcut",
    name = "Schall-AC-link",
    order = "h[hotkeys]-l[linked-chest]-1[reload]",
    -- action = "lua",
    action = "spawn-item",
    associated_control_input = "event-Schall-AC-link",
    technology_to_unlock = cfg1.tech_steelpro_name,
    item_to_spawn = cfg1.AC_sel_tool_name,
    -- style = "orange",
    icons = {
        {
          icon = "__autolinked-chest__/graphics/icons/link-chests-x32.png",
          priority = "extra-high-no-scale",
          icon_size = 32,
          scale = 1,
          flags = {"gui-icon"}
        },
    },
    small_icons = {
        {
          icon = "__autolinked-chest__/graphics/icons/link-chests-x24.png",
          priority = "extra-high-no-scale",
          icon_size = 24,
          scale = 1,
          flags = {"gui-icon"}
        },
    }
  },
}
