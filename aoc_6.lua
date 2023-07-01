require('library')

local signal = string_to_character_table(read_txt('input/input_6.txt')[1])


--print(signal[1])

--function find_unique_run(signal_table, start_pos, num_unique)
--  --find the first run of num_unique unique consecutive values in signal_table starting at start_pos 
--  local last_match_indices = {}
  
--  for i = num_unique + start_pos - 1, #signal_table do
--    local unique = true
    
--    for j = 1, num_unique - 1 do
      
--      if signal_table[i] == signal_table[i - j] then
--        last_match_indices[j] = i
--        unique = false
--        break
--      end
      
--    end
    
--    if unique then
--      if (i - (last_match_index  - last_match_length - 1)) > (num_unique) then
--        return({index = i, last_match_index = last_match_index, last_match_length = last_match_length})
--      end
--    end
    
--  end
  
--end

--function matches_out_of_bounds(current_position, last_matches, num_unique)
--  local all_unique = true
  
--  for i = 1, num_unique do
    
--  end
  
--end

--local guess = find_unique_run(signal, 1, 4)

--print('guess at index', guess.index)
--print('last_match index', guess.last_match_index)
--print('last_match length', guess.last_match_length)
--print('last sequence', signal[guess.index - 4], signal[guess.index - 3], signal[guess.index - 2], signal[guess.index - 1], signal[guess.index])




--This one fails at index 76 in the the case of a 'dmmdw' string and inspired the last_match table approach
--function find_unique_run(signal_table, start_pos, num_unique)
--  --find the first run of num_unique unique consecutive values in signal_table starting at start_pos
--  local last_match_length = 1
--  local last_match_index = 0
  
--  local last_match_indices = {}
  
--  for i = num_unique + start_pos - 1, #signal_table do
--    local unique = true
--    for j = 1, num_unique - 1 do
--      if signal_table[i] == signal_table[i - j] then
--        last_match_length = j
--        last_match_index = i
--        unique = false
--        break
--      end
--    end
--    if unique and (i - (last_match_index  - last_match_length - 1)) > (num_unique) then
--      return({index = i, last_match_index = last_match_index, last_match_length = last_match_length})
--    end
--  end
  
--end

function find_distances(signal_table, num_unique)
  --find the distances between each character and their previous duplicate
  --store those distances in each index
  local last_match_distances = {}
  
  for i = 1, #signal_table do
    last_match_distances[i] = 0
    for j = 1, num_unique - 1 do
      
      if signal_table[i] == signal_table[i - j] then
        last_match_distances[i] = j
        break
      end
      
    end
    
  end
  
  return last_match_distances
  
end

function find_unique_index(signal_table, num_unique)
  local distances = find_distances(signal_table, num_unique)
  
  local output = {}
  
  for i = num_unique, #signal_table do
    local nums_in_scope_are_unique = true
    for j = 1, num_unique do
      current_distance = distances[i - (j - 1)]
      if not(current_distance == 0 or current_distance > (num_unique - j)) then 
        nums_in_scope_are_unique = false
        break 
      end
    end
    
    output[i] = nums_in_scope_are_unique
--    if nums_in_scope_are_unique then
--      return(i)
--    end
    
  end
  
  return(output)
  
end

function get_true_indices(input_table)
  local output = {}
  for k, v in pairs(input_table) do
    if v then table.insert(output, k) end
  end
  return(output)
end

local current_guess = find_unique_index(signal, 4)

local index_guesses = get_true_indices(current_guess)

--print_table(current_guess, 1, #current_guess)

--print('distances')
--print(table.concat(find_distances(signal, 4), ','))

--print('guesses')
--print(table.concat(index_guesses, ','))

print('part 1 answer', index_guesses[1]) -- 0.04 seconds

--part 2

current_guess = find_unique_index(signal, 14)

index_guesses = get_true_indices(current_guess)

print('part 2 answer', index_guesses[1])






