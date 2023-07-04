require('library')

--load raw input text
directory_dump = read_txt('input/input_7.txt')

--parse the directory dump and establish a file tree 
--(table where key = directory, value = table of items in the folder)

local cur_dir = '/'
local file_tree = {['/'] = {}}

for i = 1, #directory_dump do
  local current_instruction = directory_dump[i]
  local first_character = string.sub(current_instruction, 1, 1)
  
  if current_instruction == '$ ls' then --list files, no action taken
    --nothing
  elseif current_instruction == '$ cd /' then --cd root directory, reset cur_dir
    cur_dir = '/'
  elseif current_instruction == '$ cd ..' then --go up a directory, remove end of cur_dir
    cur_dir = string.gsub(cur_dir, '%w+/$', '')
  elseif first_character == '$' then -- only other $ command left is $ cd 'folder', add that to cur_dir
    cur_dir = cur_dir .. string.gsub(current_instruction, '%$ cd ', '') .. '/'
  elseif first_character == 'd' then -- if dir 'folder', get folder details, add to file tree as item in cur_dir, initialize blank table for the subfolder
    local item_name = string.gsub(current_instruction, 'dir ', '')
    local folder_details = {
      ['type'] = 'folder',
      ['dir'] = cur_dir,
      ['name'] = item_name,
      ['full_name'] = cur_dir .. item_name .. '/',
      ['size'] = 0
    }
    table.insert(file_tree[cur_dir], folder_details)
    file_tree[folder_details['full_name']] = {}
  else --only command left is the file, get file details, add to file tree
    local item_name = string.gsub(current_instruction, '%d+ ', '')
    local file_details = {
      ['type'] = 'file',
      ['dir'] = cur_dir, 
      ['name'] = item_name, 
      ['full_name'] = cur_dir .. item_name,
      ['size'] = string.gsub(current_instruction, ' %w+%.*%w*', '')
    }
    table.insert(file_tree[cur_dir], file_details)
  end
end

--Math/recursion stuff here

function get_folder_value(folder_values, file_tree, target_dir)
  --calculate the total size of the target_dir
  -- if there are other folders in target_dir, resursively calculate their size
  local current_value = 0
  
  for _, item in pairs(file_tree[target_dir]) do
    if item['type'] == 'file' then
      current_value = current_value + item['size'] --increment value of current folder
    elseif item['type'] == 'folder' then
      local next_folder = item['full_name']
      local next_folder_value = 0
      folder_values, next_folder_value = get_folder_value(folder_values, file_tree, next_folder) --call the function again, one level deeper
      current_value = current_value + next_folder_value
    end
  end

  table.insert(folder_values, {['name'] = target_dir, ['size'] = current_value}) --append current value onto the running folder_values table
  return folder_values, current_value --return the folder_values for all folders calculated thus far and the value of the current directory
  
end

local all_values, outermost = get_folder_value({}, file_tree, '/') --Get the folder values, starting at top level

local qualified_folders = {}
folder_size_max = 100000

for k, v in pairs(all_values) do
  if v['size'] <= folder_size_max then
    table.insert(qualified_folders, v)
  end
end

print('total file sum: ', sum(all_values, 'size')) --232139107
print('outermost dir size: ', outermost)
print('size of folders under 100000: ', sum(qualified_folders, 'size')) --1792222

--Part 2
--Find smallest directory to delete to have less than 40000000 units of size on the drive

local min_folder_size = outermost - 40000000

table.sort(all_values, function(a, b) return a['size'] < b['size'] end)

local folder_to_delete = {}

for i = 1, #all_values do
  if all_values[i]['size'] > min_folder_size then
    table.insert(folder_to_delete, all_values[i])
    break 
  end
end

print('size of folder to delete: ', folder_to_delete[1]['size'])

