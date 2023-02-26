local h = require("Helpers")
local args = {...}

local depth = tonumber(args[1]) or tonumber(args) or 3
local height = tonumber(args[2]) or 3
local width = tonumber(args[3]) or 3

local distanceDug = 0

function digColumns(dir, x, down)
  h.move(dir, x)
  if down then h.move("down") end
end

local returnDir = false
function digStairsLayer(x, y, z)
  local direction = z % 2 == 1 and returnDir and "right" or "left"
  local returnDirection = direction == "right" and "left" or "right"

  for i = 1, y + 1 do
    local down = true
    if i == y + 1 then down = false end

    if returnDir then
      digColumns(returnDirection, x, down)
      returnDir = false
    else
      digColumns(direction, x, down)
      returnDir = true
    end
  end

  if z < depth then print(z .. "st layer done") end
  distanceDug = distanceDug + 1
end

print("--Starting to Dig--")

for z = 1, depth do
  h.move("up", height - 1) -- goes up to starting point (z-axis)
  h.move() -- Starts layer (z-axis)
  digStairsLayer(width - 1, height, z)
end

print("Distance dug -> " .. distanceDug)
