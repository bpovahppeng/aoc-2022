require('library')

--Initialize a matrix of trees
tree_map = read_txt('input/input_8.txt')

tree_table = {}

for i = 1, #tree_map do
    table.insert(tree_table, string_to_character_table(tree_map[i]))
end

--iterate through the tree matrix based on the current direction

function determine_visible_trees(all_trees, visible_trees, direction)
  local start_outer
  local start_inner
  local end_outer
  local end_inner
  local increment_outer
  local increment_inner
  
  if direction == "right" or direction == "down" then
    start_outer = 1
    start_inner = 1
    end_outer = #all_trees
    end_inner = #all_trees[1]
    increment_outer = 1
    increment_inner = 1
  elseif direction == "left" or direction == "up" then
    start_outer = 1
    start_inner = #all_trees[1]
    end_outer = #all_trees
    end_inner = 1
    increment_outer = 1
    increment_inner = -1
  end
  
  for i = start_outer, end_outer, increment_outer do
    local tree_num = 1 
    local tallest_tree = -1
    for j = start_inner, end_inner, increment_inner do
        if tree_num > 99 then tree_num = 1 end

        if direction == "right" or direction == "left" then
            if tonumber(all_trees[i][j]) > tallest_tree or tree_num == 1 then
                tallest_tree = tonumber(all_trees[i][j])
                visible_trees[i][j] = tallest_tree
            end
        elseif direction == "down" or direction == "up" then
            if tonumber(all_trees[j][i]) > tallest_tree or tree_num == 1 then
                tallest_tree = tonumber(all_trees[j][i])
                visible_trees[j][i] = tallest_tree
            end
        end
        tree_num = tree_num + 1
        if tallest_tree == 9 then
            break
        end
    end
  end
  
  return(visible_trees)
end

--create a table of visible trees, with an empty matrix for each row in tree_table
local visible_trees = {}
for i = 1, #tree_table do
    table.insert(visible_trees, {})
end

visible_trees = determine_visible_trees(tree_table, visible_trees, "right")
visible_trees = determine_visible_trees(tree_table, visible_trees, "left")
visible_trees = determine_visible_trees(tree_table, visible_trees, "down")
visible_trees = determine_visible_trees(tree_table, visible_trees, "up")

function count_trees(trees)
  
  local count = 0
  
  for i = 1, #trees do
    for k, v in pairs(trees[i]) do
      if v then 
        count = count + 1 
      end
    end
  end
  return count
end

print(count_trees(visible_trees))

--Part 2

function scenic_score(all_trees, x, y)
  
  local directions = {'right', 'up', 'left', 'down'}
  
  local scores = {}
  
  for _, direction in pairs(directions) do
    table.insert(scores, get_distance(all_trees, x, y, direction))
  end
  
  return scores[1] * scores[2] * scores[3] * scores[4]
  
end

function get_distance(all_trees, x, y, direction)
  local height = tonumber(all_trees[y][x])
  
  local distance = 0
  
  local continue = true
  
  local x_min = 1
  local x_max = #all_trees[1]
  local y_min = 1
  local y_max = #all_trees
  
  while continue do
    x, y = get_next_coords(x, y, direction)
    
    if x < x_min or x > x_max or y < y_min or y > y_max then
      continue = false
    else
        local next_height = tonumber(all_trees[y][x])

        if next_height == nil or next_height >= height then
            continue = false
        end
        
        distance = distance + 1
    end

  end

  if distance == 0 then distance = 1 end

  return distance
end

function get_next_coords(x, y, direction)
  
  if direction == 'right' then
    x = x + 1
  elseif direction == 'left' then
    x = x - 1
  elseif direction == 'down' then 
    y = y + 1
  elseif direction == 'up' then
    y = y -1
  end
  
  return x, y
end

local best_score = 0
for i = 1, #tree_table do
  for j = 1, #tree_table[1] do
    current_score = scenic_score(tree_table, j, i)
    --print(j, i, current_score)
    if current_score > best_score then
      best_score = current_score
    end
  end
end

print(best_score)
