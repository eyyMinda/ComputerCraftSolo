local h = require("Helpers")

local args = ...

local distanceToDig = tonumber(args) or 5
local distanceDug = 0

function dig2x2()
  local digCount = 0

  local moveFuncs = {
    [1] = function() h.move("right", 1) end,
    [2] = function() h.move("up", 1) end,
    [3] = function() h.move("left", 1) end,
    [4] = function() h.move("down", 1) end

  }

  local function dig()
    turtle.dig()
    digCount = digCount + 1
    if digCount == 4 then
      digCount = 0
      h.move("forward", 1)
    end
  end

  while distanceDug < distanceToDig do
    for i = 1, 4 do
      dig()
      moveFuncs[i]()
    end

    -- moveFuncs[4]()
    distanceDug = distanceDug + 1
  end
end

-------------------------------------------------
-- Main
-------------------------------------------------

shell.run("clear")

dig2x2()
print("Distance dug -> " .. distanceDug)

