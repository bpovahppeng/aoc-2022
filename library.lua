function read_txt(file_name)
  --need to write a function to load a txt file as a table line by line
  local raw_lines = {}
  for line in io.lines(file_name) do
    table.insert(raw_lines, line)
  end
  
  return(raw_lines)
end

function sum(table)
  --lua doesn't have a built in method to sum values in a table
  --we have to implement one
    local sum = 0
    for i = 1, #table do
        sum = sum + table[i]
    end
    return(sum)
end

function print_table(table, start_index, end_index)
  for k, v in pairs(table) do
    if k < start_index then
      --do nothing
    else if k < end_index + 1 then
      print(k, v)
    else
      break end
    end
  end
  
  return(nil)
end

function extract_all(text, pattern, format)
  --extract all matches of the pattern within text to a table: 'move 3 from 2 to 5' becomes {3, 2, 5} given the pattern '%d+'
  local result = {}
  for match in string.gmatch(text, pattern) do
    if format == 'number' then match = tonumber(match) end
    table.insert(result, match)
  end
  return(result)
end

function string_to_character_table(text)
  --converts a string to a table of characters
  local character_table = {}
  for i = 1, text:len() do
    table.insert(character_table, text:sub(i, i))
  end
  return(character_table)
end

return({read_txt, sum, print_table, extract_all, string_to_character_table})