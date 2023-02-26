-------------------------------------------------
-- Global Functions
-------------------------------------------------
--[[]] --
--- Splits a string into substrings using a delimiter pattern and returns them as an array.
---@param string string: String to split.
---@param delimiter string: Delimiter pattern used to split the string. Can be a string or a Lua pattern.
---@param limit number|nil:  Maximum number of substrings to return. If not provided, all substrings are returned.
--- #
---@return table: An array containing the substrings.
local function split(string, delimiter, limit)
  local result = {}
  local pos = 1
  while true do
    local start, stop = string.find(string, delimiter, pos, true)

    if not start then break end
    if limit and #result >= limit then break end

    table.insert(result, string.sub(string, pos, start - 1))
    pos = stop + 1
  end
  table.insert(result, string.sub(string, pos))
  return result
end

--- Concatenates a list of strings into a single string with the specified delimiter separating each element.
---@param delimiter string: The string to be used as the separator between each element.
---@param list table: An array of strings to be concatenated.
--- #
---@return string: The resulting concatenated string.
local function join(delimiter, list) return table.concat(list, delimiter, 1, #list - 1) .. " and " .. list[#list] end

--- Checks if the given string starts with the specified piece.
--- @param str string: The string to check.
--- @param piece string: The piece to check if the string starts with.
--- #
--- @return boolean: Returns true if the string starts with the piece, false otherwise.
local function starts(str, piece) return string.sub(str, 1, string.len(piece)) == piece end

--- Checks if the given string ends with the specified piece.
--- @param str string: The string to check.
--- @param piece string: The piece to check if the string ends with.
--- #
--- @return boolean: Returns true if the string ends with the piece, false otherwise.
local function ends(str, piece) return string.sub(str, -string.len(piece)) == piece end

--- Returns a new table containing a portion of the given table `values`,
--- starting at index `from` and ending at index `to`.
--- 
--- If `from` is not specified or is nil, it defaults to 1.
--- If `to` is not specified or is nil, it defaults to the length of `values`.
--- 
--- If `to` is negative, it indicates an offset from the end of the table.
--- If `from` or `to` is out of range, an empty table is returned.
--- 
--- @param values table: The table to slice.
--- @param from number: (optional) Starting index of the slice (default: 1)
--- @param to number: (optional) Ending index of the slice (default: the length of `values`).
--- #
--- @return table: A new table containing the sliced portion of the original table.
local function slice(values, from, to)
  from, to = from or 1, to or #values
  if to < 0 then to = #values + to + 1 end

  from, to = math.max(from, 1), math.min(to, #values)
  if from > to then return {} end

  return {table.unpack(values, from, to)}
end

--- This function will print the table provided as a string
---@param table table
local function printTable(table)
  local tableString = ""
  -- Concatenate each item in the table to the tableString variable
  for _, value in ipairs(table) do tableString = tableString ~= "" and tableString .. ", " .. value or value end
  -- Print the resulting string
  print(tableString)
end

-------------------------------------------------
-- Turtle
-------------------------------------------------

--- - This function moves the turtle in the specified direction for the specified number of steps,
--- - and optionally sucks up items in the turtle's path.
---@param direction string: "forward" or "back"
---@param steps number: the number of steps to move
---@param dig boolean: (optional) whether or not to dig blocks that are blocking your way (default: true)
---@param suck boolean: (optional) whether or not to suck up items (default: true)
local function move(direction, steps, dig, suck)
  local moveFuncs = {
    ["forward"] = turtle.forward,
    ["back"] = turtle.back,
    ["up"] = turtle.up,
    ["down"] = turtle.down
  }
  direction, steps = direction or "forward", steps or 1
  dig, suck = dig or true, suck or true
  local moveFunc = moveFuncs[direction] or turtle.forward

  if direction == "left" and turtle.turnLeft() or direction == "right" and turtle.turnRight() then end

  for i = 1, steps do
    if dig and turtle.detect() then
      turtle["dig" .. (direction == "up" and "Up" or direction == "down" and "Down" or "")]()
    end
    if suck then turtle.suck() end

    moveFunc()
  end

  if direction == "left" and turtle.turnRight() or direction == "right" and turtle.turnLeft() then end
end

--- This function turns the turtle in the specified direction for the specified number of times.
---@param direction string: "left" or "right"
---@param times number: the number of times to turn
local function turn(direction, suck)
  suck = suck or true
  local turnFunc = direction == "left" and turtle.turnLeft or turtle.turnRight
  local times = direction ~= nil and 1 or 2

  for i = 1, times do
    turnFunc()
    if suck then turtle.suck() end
  end
end

--- - This function inspects wether there is a block in a specified direction;
--- - Then check wether the block matches the name provided.
---@param name string: name of the desired block
---@param direction string: "up" or "down" (default: inspects infront)
--- #
---@return boolean
local function isBlock(name, direction)
  local has_block, data = turtle["inspect" .. (direction == "up" and "Up" or direction == "down" and "Down" or "")]()

  return has_block and string.find(data.name, name, 1, true) ~= nil
end

--- - This function checks if the desired item is in turtle's inventory;
---@param name string: name of the desired item
--- #
---@return number | nil
local function findInInventory(name)
  local slotCount = 16
  for x = 1, slotCount do
    local currentItem = turtle.getItemDetail(x)
    if currentItem and string.match(currentItem.name, name) then
      turtle.select(x)
      return x
    end
  end
  return nil
end

--- This function will deposit every item except for arguments provided
--- #
--- Example: `depositItems("sapling", "log")`
--- @param any string: excluded item
local function depositItems(...)
  local exclusions = {...}
  local slotCount = 16
  for x = 1, slotCount do
    local currentItem = turtle.getItemDetail(x, false)

    if currentItem ~= nil then
      local shouldExclude = false
      for _, item in ipairs(exclusions) do
        if string.match(currentItem.name, item) then
          shouldExclude = true
          break
        end
      end

      if not shouldExclude then
        print("Depositing")
        turtle.select(x)
        turtle.drop()
      end
    end
  end
end

return {
  split = split,
  join = join,
  starts = starts,
  ends = ends,
  slice = slice,
  printTable = printTable,

  isBlock = isBlock,
  move = move,
  turn = turn,
  findInInventory = findInInventory,
  depositItems = depositItems
}
