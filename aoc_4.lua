require('library')

raw_input = read_txt('input/input_4.txt')

--[[
Sample input:
37-87,36-87
3-98,3-84
33-73,33-33
3-65,1-3
59-72,41-59
]]--

function split_in_two(text, pattern)
  --splits a string in two parts, based on a regex pattern with two capture groups
  local split = {}
  
  for start, finish in string.gmatch(text, pattern) do
    split[1] = start
    split[2] = finish
  end
  
  return(split)
end


function convert_pair_to_assignments(text)
  --converts a string like '3-5,7-9' to a table like {'3-5', '7-9'}
  local assignments = split_in_two(text, '(%d+%-%d+),(%d+%-%d+)')
  
  return(assignments)
end

--convert the raw input to a table of assignments
local input_assignments = {}
for i = 1, #raw_input do
  table.insert(input_assignments, convert_pair_to_assignments(raw_input[i]))
end

function convert_assignment_to_boolean(text)
  --converts a string like '3-5' to a boolean table like {false, false, true, true, true}
  local assignment = split_in_two(text, '(%d+)%-(%d+)')

  local boolean_table = {}
  for i = assignment[1], assignment[2] do 
    boolean_table[i] = true
  end
  
  return(boolean_table)
end

function get_min_max_index(table)
  --get the lowest and largest index of a table
  local min
  local max
  for k, v in pairs(table) do
    min = math.min(min or k, k)
    max = math.max(max or k, k)
  end
  return({min, max})
end

function ranges_overlap(range1, range2, complete_overlap)
  --check if two ranges overlap
  --if complete_overlap is true, one range must be represented completely in the other
  --if complete_overlap is false, the ranges must overlap in at least one position

  local range1_table = convert_assignment_to_boolean(range1)
  local range2_table = convert_assignment_to_boolean(range2)

  local min_max_1 = get_min_max_index(range1_table)
  local min_max_2 = get_min_max_index(range2_table)
  
  local overlap_count = 0
  for i = math.min(min_max_1[1], min_max_1[2]), math.max(min_max_2[1], min_max_2[2]) do
    if range1_table[i] and range2_table[i] then
      overlap_count = overlap_count + 1
    end
  end
  
  if complete_overlap then
    return overlap_count == math.min(min_max_1[2] - min_max_1[1] + 1, min_max_2[2] - min_max_2[1] + 1)
  end
  
  return overlap_count > 0
end

function count_overlaps(assignments, complete_overlap)
  local overlaps = 0
  for i = 1, #assignments do
    if ranges_overlap(assignments[i][1], assignments[i][2], complete_overlap) then
      overlaps = overlaps + 1
    end
  end
  return(overlaps)
end

print('part 1 overlaps', count_overlaps(input_assignments, true))
print('part 2 overlaps', count_overlaps(input_assignments, false))