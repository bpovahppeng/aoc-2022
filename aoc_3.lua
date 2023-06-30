require('library')

local raw_lines = read_txt("input/input_3.txt")

--Define needed functions
function get_priority(letter)
  --find the letters ASCII value, do math to get the priority set by AoC
  local value = letter:byte()
  if value > 96 then
    priority = value - 96
  else
    priority = value - 38
  end
  return(priority)
end

--Part 1

--split lines into the first and second compartments
local first = {}
local second = {}
local length = 0
local num_packs = #raw_lines
local temp_first = ""
local temp_second = ""


for pack = 1, num_packs do
  length = #raw_lines[pack]
  --print(length)
  
  temp_first = string.sub(raw_lines[pack], 1, length / 2)
  temp_second = string.sub(raw_lines[pack], length / 2 + 1, length)
  
  table.insert(first, temp_first)
  table.insert(second, temp_second)

end

--Iterate for duplicates and sum priority
local priorities = {}

for pack = 1, num_packs do
  local first_pouch = first[pack]
  for index = 1, #second[pack] do
    local current_letter = second[pack]:sub(index, index)
    if first_pouch:find(current_letter) then
      table.insert(priorities, get_priority(current_letter))
      break
    end
  end 
end

print("Part 1 answer:", sum(priorities))

--Part 1 ran in 0.04 seconds on my Steam Deck in desktop mode

--Part 2

--Iterate through groups and sum priorities
local num_groups = num_packs / 3
local priorities_part_2 = {}

for group = 1, num_groups do
  local pack_1 = raw_lines[3 * (group - 1) + 1]
  local pack_2 = raw_lines[3 * (group - 1) + 2]
  local pack_3 = raw_lines[3 * (group - 1) + 3]

  for index = 1, #pack_3 do
    local current_letter = pack_3:sub(index, index)
    if pack_1:find(current_letter) and pack_2:find(current_letter) then
      table.insert(priorities_part_2, get_priority(current_letter))
      break
    end
  end
end

print("Part 2 answer:", sum(priorities_part_2))
--the whole script runs in 0.05 seconds
