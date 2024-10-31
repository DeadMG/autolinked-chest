local cfg1 = require("config.config-1")



data:extend
{
  {
    type = "custom-input",
    name = "event-Schall-AC-link",
    key_sequence = "CONTROL + O",
    consuming = "game-only",
    action = "spawn-item",
    item_to_spawn = cfg1.AC_sel_tool_name,
  }
}
