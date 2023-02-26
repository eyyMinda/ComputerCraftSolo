local h = require("Helpers")
local args = ...

local rows = 3
local cols = 3
local depth = tonumber(args) or 3
local distanceDug = 0

local moveFuncs = {
  [1] = function() h.move("right") end,
  [2] = function() h.move("left") end,
  [3] = function() h.move("up") end,
  [4] = function() h.move("down") end
}

local getNextRowFunc = function(even) return even and moveFuncs[4] or moveFuncs[3] end
local getNextColFunc = function(even) return even and moveFuncs[1] or moveFuncs[2] end

local function digSpiralLayer(rows, cols, z, rowFunc)
  for x = 1, rows do
    local start, end_, step = 1, cols, 1
    local colFunc = getNextColFunc(z % 2 == 1) -- slideRight

    if x % 2 == 0 then
      start, end_, step = cols, 1, -1
      colFunc = getNextColFunc(z % 2 == 0) -- slideLeft
    else
      end_ = cols
    end

    for y = start, end_, step do
      print("Digging block at (" .. x .. ", " .. y .. ", " .. z .. ")")
      turtle.dig()
      if y ~= end_ then
        colFunc() -- slides to the side (x-axis)
      end
    end
    rowFunc() -- slides up or down (y-axis)
  end
  distanceDug = distanceDug + 1
end

for z = 1, depth do
  local rowFunc = getNextRowFunc(z % 2 == 0) -- returns down if true, up if false

  digSpiralLayer(rows, cols, z, rowFunc)
  h.move("forward", 1) -- goes further (z-axis)
end

print("Distance dug -> " .. distanceDug)
