local AC_1_inventory_sizes = {
  8,
  16,
  24,
  32,
  40,
  48,
}

local AC_1_inventory_limits = {
  0,
  1,
  2,
  3,
  4,
  5,
  10,
  20,
  30,
  40,
  48,
}


data:extend
{
  -- Autolinked Chest
  {
    type = "int-setting",
    name = "Schall-AC-autolinked-chest-1-inventory",
    order = "ac-i-1",
    setting_type = "startup",
    default_value = 48,
    allowed_values = AC_1_inventory_sizes,
  },
  {
    type = "int-setting",
    name = "Schall-AC-autolinked-chest-1-default-inventory-limit",
    order = "ac-j-1",
    setting_type = "runtime-global",
    default_value = 48,
    allowed_values = AC_1_inventory_limits,
  },
  {
    type = "string-setting",
    name = "Schall-AC-link-id-flying-text",
    order = "ac-t-1",
    setting_type = "runtime-per-user",
    allowed_values = {"NONE", "oct", "dec", "hex", "hex-zero-padding"},
    default_value = "NONE"
  },
  {
    type = "bool-setting",
    name = "Schall-AC-link-chests-built-enable",
    order = "ac-x-1",
    setting_type = "runtime-global",
    default_value = true
  },
  {
    type = "bool-setting",
    name = "Schall-AC-link-chests-hotkey-shortcut-enable",
    order = "ac-x-2",
    setting_type = "runtime-global",
    default_value = true
  },
}
