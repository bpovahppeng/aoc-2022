require('library')

--load raw input text
directory_dump = read_txt('input/input_7.txt')

--set up some functions to go with each type of instruction

function get_file_name(current_directory, file_details)
    local file_name = extract_all(file_details, '%w+%.%w+')[1]
    return(file_name)
end

function get_file_size(file_details)
    return(extract_all(file_details, '%d+', 'number')[1])
end

function up_dir(current_directory)
    --goes with the command 'cd ..'
    --remove the last word and the preceding '/' from the current directory
    return(string.gsub(current_directory, '%w+/$', ''))
end

function into_dir(current_directory, instruction)
    
end

local current_dir_test = '/in/out/out'
--print(up_dir(current_dir_test))

local file_test = '2069 asdf.pg'
--print(get_file_size(file_test))
--print(get_file_name(current_dir_test, file_test))

local file_list = {}
local folder_list = {}
local cur_dir = '/'
local file_tree = {['/'] = {}}

for i = 1, #directory_dump do
  local current_instruction = directory_dump[i]
  local first_character = string.sub(current_instruction, 1, 1)
  
  if current_instruction == '$ ls' then --list files, no action taken
    --nothing
  elseif current_instruction == '$ cd /' then --root directory, reset cur_dir
    cur_dir = '/'
  elseif current_instruction == '$ cd ..' then --remove end of cur_dir
    cur_dir = up_dir(cur_dir)
  elseif first_character == '$' then -- only other $ command left is $ cd 'folder', add that to cur_dir
    cur_dir = cur_dir .. string.gsub(current_instruction, '%$ cd ', '') .. '/'
  elseif first_character == 'd' then -- if dir 'folder', add to folder list
    local folder_details = {
      ['type'] = 'folder',
      ['dir'] = cur_dir,
      ['name'] = string.gsub(current_instruction, 'dir ', ''),
      ['full_name'] = cur_dir .. string.gsub(current_instruction, 'dir ', '') .. '/',
      ['size'] = 0
    }
    table.insert(folder_list, folder_details)
    file_tree[cur_dir .. string.gsub(current_instruction, 'dir ', '') .. '/'] = {}
  else --only command left is the file, add that to file list
    local file_details = {
      ['type'] = 'file',
      ['dir'] = cur_dir, 
      ['name'] = string.gsub(current_instruction, '%d+ ', ''), 
      ['size'] = string.gsub(current_instruction, ' %w+%.*%w*', '')
    }
    print('current line: ', i)
    print(cur_dir)
    table.insert(file_list, file_details)
    table.insert(file_tree[cur_dir], file_details)
  end
end

for i = 1, 10 do
  print(i, file_list[i]['dir'], file_list[i]['name'], file_list[i]['size'])
end

for i = 1, 10 do
  print(i, folder_list[i]['dir'], folder_list[i]['name'], folder_list[i]['size'])
end

local folder_full_names = {}
for i = 1, #folder_list do
  table.insert(folder_full_names, folder_list[i]['full_name'])
end

local current_folder = '/qffvbf/'
print(file_tree[current_folder][1]['size'])

--print_table(file_list, 1, 10)


--Take 2, list of lists

--develop the file tree
--file_tree = {}

--function parse_instructions(current_folder, current_instructions)
  
--end

--function get_navigation_lines(instruction_list)
--  local navigation_lines = {}
--  for k, v in pairs(instruction_list) do
--    if string.match(v, '^%$ cd.*$') then
--      table.insert(navigation_lines, k)
--    end
--  end
--  return(navigation_lines)
--end

----for i = 1, #directory_dump do
  
----end



--local nav_lines = get_navigation_lines(directory_dump)

--print_table(directory_dump, 1, 20)
--print_table(nav_lines, 1, #nav_lines)
--print(nav_lines[1])

--tests
--local test = {}
--test[1] = {['abc'] = 5}
----table.insert(test, {abc = {5}})
--print(test[1]['abc'])
