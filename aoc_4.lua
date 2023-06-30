require('library')

raw_input = read_txt('input/input_4.txt')

--print(raw_input[1])

function split_in_two(text, pattern)
  local split = {}
  
  for start, finish in string.gmatch(text, pattern) do
    split[1] = start
    split[2] = finish
  end
  
  return(split)
end


function convert_pair_to_assignments(text)
  local assignments = split_in_two(text, '(%d+%-%d+),(%d+%-%d+)')
  
  return(assignments)
end

local input_assignments = {}
for i = 1, #raw_input do
  table.insert(input_assignments, convert_pair_to_assignments(raw_input[i]))
end

--print('first assignments', convert_pair_to_assignments(raw_input[1])[1], convert_pair_to_assignments(raw_input[1])[2])
print('assignments', input_assignments[3][1], input_assignments[3][2])


--function convert_assignment_to_range(text)
  
--  local assignment = split_in_two(text, '(%d+)%-(%d+)')

--  local range = {}
--  for i = assignment[1], assignment[2] do 
--    table.insert(range, i)
--  end
  
--  return(range)
--end

function convert_assignment_to_boolean(text)
  
  local assignment = split_in_two(text, '(%d+)%-(%d+)')

  local boolean_table = {}
  for i = assignment[1], assignment[2] do 
    boolean_table[i] = true
  end
  
  return(boolean_table)
end



--function range_to_boolean(range)
--  local boolean_table = {}
--  for k, v in pairs(range) do
--    boolean_table[v] = true
--  end
  
--  return(boolean_table)
--end
print('length', #raw_input, #input_assignments)

local input_booleans = {}
for i = 1, #input_assignments do
--  boolean_1 = convert_assignment_to_boolean(input_assignments[i][1])
--  boolean_2 = convert_assignment_to_boolean(input_assignments[i][2])
  input_booleans[i] = {}
  input_booleans[i][1] = convert_assignment_to_boolean(input_assignments[i][1])
  input_booleans[i][2] = convert_assignment_to_boolean(input_assignments[i][2])
  
  --table.insert(input_booleans, {convert_assignment_to_boolean(raw_input[i]))
end

print('length', #input_assignments, #input_booleans)

function get_boolean_length(boolean)
  local min = math.huge
  local max = 0
  
  for k, v in pairs(boolean) do
    if k < min then min = k end
    max = k
  end
  
  return(max + 1 - min)
end

function find_total_overlap(boolean_1, boolean_2)

  length_boolean_1 = get_boolean_length(boolean_1)
  length_boolean_2 = get_boolean_length(boolean_2)

  local num_matches = 0
  
  for k, v in pairs(boolean_1) do
    print(k, boolean_1[k], boolean_2[k])
    if(boolean_1[k] and boolean_2[k]) then
      --print('above matched')
      num_matches = num_matches + 1
    end
  end
  
  if num_matches == length_boolean_1 or num_matches == length_boolean_2 then
    --print('the above set matched')
    return(true)
  end
  --print('the above set didnt match')
  return(false)
end

local overlaps = {}
local num_overlaps = 0
for pair = 1, #input_booleans do
  
  local total_match = find_total_overlap(input_booleans[pair][1], input_booleans[pair][2])
  
  if total_match then num_overlaps = num_overlaps + 1 end
  
  table.insert(overlaps, total_match)
  
  --print(pair, total_match)
  
--  local length_1 = #input_booleans[pair][1]
--  local length_2 = #input_booleans[pair][2]
  
--  local num_matches = 0
  
--  for k, v in pairs(input_booleans[pair][1]) do
--    if(input_booleans[pair][1][k] and input_booleans[pair][2][k]) then
--      num_matches = num_matches + 1
--    end
--  end
  
--  if num_matches == length_1 or num_matches == length_2 then
--    num_total_overlaps = num_total_overlaps + 1
--  end
  
end

print_table(input_booleans[3][2])

print(num_overlaps)

find_total_overlap(input_booleans[5][1],input_booleans[5][2])

--why does it think that 5 matches?

