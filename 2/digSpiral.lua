local h = require("Helpers")
local args = {...}

local depth = tonumber(args[1]) or tonumber(args) or 3
local rows = tonumber(args[2]) or 3
local cols = tonumber(args[3]) or 3
local distanceDug = 0

local moveFuncs = {
  [1] = function(steps) h.move("right", steps) end,
  [2] = function(steps) h.move("left", steps) end,
  [3] = function(steps) h.move("up", steps) end,
  [4] = function(steps) h.move("down", steps) end
}

local getNextRowFunc = function(even) return even and moveFuncs[4] or moveFuncs[3] end
local getNextColFunc = function(even) return even and moveFuncs[1] or moveFuncs[2] end

local function digSpiralLayer(rows, cols, z, rowFunc)
  for x = 1, rows do

    local colFunc = x % 2 == 0 and getNextColFunc(z % 2 == 0) or getNextColFunc(z % 2 == 1)

    print("Digging row -> (" .. x .. ", " .. z .. ")")
    colFunc(cols - 1) -- dig to the side (x-axis)

    if x < rows then
      rowFunc() -- slides up or down (y-axis)
    end
  end
  distanceDug = distanceDug + 1
end

for z = 1, depth do
  local rowFunc = getNextRowFunc(z % 2 == 0) -- returns down if true, up if false

  h.move("forward", 1) -- goes further (z-axis)
  digSpiralLayer(rows, cols, z, rowFunc)
end
print("-- Distance Dug -> " .. distanceDug .. " --")

