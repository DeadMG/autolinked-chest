local cfg1 = require("config.config-1")



for index, force in pairs(game.forces) do
  -- force.reset_technology_effects()
  local technologies = force.technologies
  local recipes = force.recipes
  
  if technologies[cfg1.tech_steelpro_name].researched then
		for tier = 1, cfg1.tier_max, 1 do
	    recipes[cfg1.AC_name(tier)].enabled = true
	  end
  end
end