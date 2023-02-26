local h = require("Helpers")
local ignoreBranches = ... or true

function cleanTree()
  local currentLevel = 0

  while h.isBlock("log") do
    h.move("up")

    currentLevel = currentLevel + 1
    print("Going Up, Current Level -> " .. currentLevel)
  end

  while currentLevel > 0 do

    if not ignoreBranches then
      print("Cleaning Surroundings on Level -> " .. currentLevel)
      for i = 1, 4 do
        local awayFromCenter = 0
        while h.isBlock("log") do h.move() end

        h.move("back", awayFromCenter)

        turtle.turnRight()
      end
    end

    h.move("down")
    currentLevel = currentLevel - 1
    print("Current Level -> " .. currentLevel)
  end

end

-------------------------------------------------
-- Main
-------------------------------------------------

shell.run("clear")

if h.isBlock("log") then
  h.move("forward")

  cleanTree()

  h.move("back")
end
