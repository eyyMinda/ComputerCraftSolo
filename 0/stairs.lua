local h = require("Helpers")
local args = {...}

local direction = tostring(args[1]) or tostring(args) or "up"
local distance = tonumber(args[2]) or tonumber(args) or 2

local function useStairs()
  if direction == "up" then
    h.move(direction)
    h.move()
  else
    h.move()
    h.move(direction)
  end
end

print("--Going " .. direction .. " --")

for y = 1, distance do useStairs() end
