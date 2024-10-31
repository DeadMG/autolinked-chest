local cfg1 = require("config.config-1")
local ACpt = require("lib.ACpt")



local dataextendlist = {}


for tier = 1, cfg1.tier_max, 1 do
	table.insert( dataextendlist, ACpt.AC_item(tier) )
	table.insert( dataextendlist, ACpt.AC_entity(tier) )
	table.insert( dataextendlist, ACpt.AC_recipe(tier) )

	local ACtech = data.raw.technology[cfg1.tech_steelpro_name]
	if ACtech and ACtech.effects then
	  table.insert(ACtech.effects, {type="unlock-recipe", recipe=cfg1.AC_name(tier)})
	else
	  log("Tech " .. cfg1.tech_steelpro_name .. " not found!  Tech effect not applied.")
	end
end


if next(dataextendlist) ~= nil then
  data:extend(dataextendlist)
end