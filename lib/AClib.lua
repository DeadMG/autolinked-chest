local AClib = {}

local showlog = false     -- Debug log message toggle
local showprint = false   -- Debug game print toggle

function AClib.debuglog(msg)
  if showlog then log(msg) end
  return showlog
end

function AClib.debugprint(msg)
  if showprint and game then game.print(msg) end
  return showprint
end



function AClib.create_flying_text_linked(surface, position, player)
  local players = player and { player } or nil
  rendering.draw_text({ text = {"description.Schall-AC-flying-text-linked"}, target = position, surface = surface, players = players, time_to_live = 60, color = { r = 1, g = 0.75, b = 0.5 } })
end

function AClib.create_flying_text_multiple_link_id(surface, position, player)
  local players = player and { player } or nil
  rendering.draw_text({ text = {"description.Schall-AC-flying-text-multiple-link-id"}, target = position, surface = surface, players = players, time_to_live = 60, color = { r = 1, g = 0.75, b = 0.5 } })
end

function AClib.create_flying_text_link_id(surface, position, link_id, player)
  local player_index = player and player.index
  local texttype = player.mod_settings["Schall-AC-link-id-flying-text"].value
  if texttype == "NONE" then return end
  local text
  if texttype == "hex" then
    text = string.format("%X", link_id)
  elseif texttype == "hex-zero-padding" then
    text = string.format("%08X", link_id)
  elseif texttype == "oct" then
    text = string.format("%o", link_id)
  else
    text = tostring(link_id)
  end
  local color = {r=1, g=1, b=1}
  local denom = 2^11  -- Rough Cubic root of 2^32, the max value of link ID.  Not using Quad root as there are only RGB parameters
  local x = link_id / denom
  x, color.b = math.modf(x)
  x = x / denom
  x, color.g = math.modf(x)
  x = x / denom
  x, color.r = math.modf(x)
  color.r = color.r * 2 -- Compensate for the last "bit" of R value, to make the text brighter
  position.y = position.y - 1
  -- Remove old flying text, so not cluttering the screen
  
  player.clear_local_flying_texts()
  player.create_local_flying_text({ text = text, position = position })
end



return AClib