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

function print_table(table)
  for k, v in pairs(table) do
    print(k, v)
  end
  
  return(nil)
end

return({read_txt, sum})