local AClib = require("lib.AClib")



local config = {}

config.mod_prefix         = "Schall-AC-"
config.mod_prefix_ptrn    = "Schall%-AC%-"

config.AC_sel_tool_name   = config.mod_prefix .. "inserter-selection-tool"
config.AC_flying_text     = config.mod_prefix .. "flying-text-static"

config.AC_type            = "linked-container"
config.AC_name_prefix     = "Schall-autolinked-chest-"
config.tier_max           = 1

config.AC_inventory_sizes = {}
for k, v in pairs(settings.startup) do
  local obj = k:match("^"..config.mod_prefix_ptrn.."autolinked%-chest%-(.*)%-inventory")
  if obj then
    local tier = tonumber(obj)
    config.AC_inventory_sizes[tier] = v.value
    AClib.debuglog("  Found tier " .. tier .. " : " .. v.value)
  end
end

config.tech_steelpro_name = "steel-processing"

function config.AC_name(tier)
  return config.AC_name_prefix .. tier
end

function config.AC_name_table()
  local rt = {}
  for tier = 1, config.tier_max do
    table.insert(rt, config.AC_name(tier))
  end
  return rt
end



return config