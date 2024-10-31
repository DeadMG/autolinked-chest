local config = {}

config.mod_prefix         = "Schall-AC-"
config.mod_prefix_ptrn    = "Schall%-AC%-"

config.AC_sel_tool_name   = config.mod_prefix .. "inserter-selection-tool"

config.AC_type            = "linked-container"
config.AC_ptrn            = "^Schall%-autolinked%-chest%-"  -- "linked%-chest"
config.AC_tier_ptrn       = "%a+%-(%d+)"
config.tier_max           = 1
config.rand_trials_max    = 16  -- Normally should not matter, but having such high number for exceptions
config.rand_trials_empty  = 8   -- Allow use of empty but non-NIL inventories, as now there is no recycling

config.AC_search_radius   = 1.1 -- Radius to detect neighbouring chests

config.linkedchest_filter = {
  {filter = "type", type = "linked-container"},
  {filter = "ghost_type", type = "linked-container"},
}

local rand_max            = 2^32 - 1  -- Highest value for randomization of link ID
function config.rand_link_id()
  return math.random(rand_max)
end



return config