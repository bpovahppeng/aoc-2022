require('library')

local starting_text = read_txt('input/input_5_starting.txt')
print(starting_text[1])
local raw_instructions = read_txt('input/input_5_instructions.txt')

--function definitions
function string_to_character_table(text)
  --converts a string to a table of characters
  local character_table = {}
  for i = 1, text:len() do
    table.insert(character_table, text:sub(i, i))
  end
  return(character_table)
end

function initialize_boxes()
  --initialize the matrix of boxes, 9 columns of tables
  for i = 1, #starting_text do
    table.insert(boxes, string_to_character_table(starting_text[i]))
  end
end

function move_one_box(start_col, end_col)
    --move the box from the end of boxes[start_col] to the end of boxes[end_col]
    local box = boxes[start_col][#boxes[start_col]]
    boxes[start_col][#boxes[start_col]] = nil
    boxes[end_col][#boxes[end_col] + 1] = box
    return(boxes)
end

function parse_instruction(text)
  --parse an instruction like 'move 3 from 2 to 5' to a table like {3, 2, 5}
  local instruction = {}
  for number in string.gmatch(text, '%d+') do
    table.insert(instruction, tonumber(number))
  end
  return(instruction)
end


--part_1

--initialize the matrix of boxes, 9 columns of tables
boxes = {}
initialize_boxes()

--iterate through the instructions and move the boxes
for i = 1, #raw_instructions do
  local instruction = parse_instruction(raw_instructions[i])
  for j = 1, instruction[1] do
    boxes = move_one_box(instruction[2], instruction[3])
  end
end

top_boxes = {}
for i = 1, #boxes do
  table.insert(top_boxes, boxes[i][#boxes[i]])
end

print('final top boxes part 1:', table.concat(top_boxes))

--part_2

--reset boxes
boxes = {}
initialize_boxes()

--functions
function move_multiple_boxes(num, start_col, end_col)
    --move num boxes from start_col to end_col without reordering them
    boxes_to_move = {}
    --look at the end of start_col and move those boxes into a temp table
    for i = #boxes[start_col] - (num - 1), #boxes[start_col] do
        table.insert(boxes_to_move, boxes[start_col][i])
        boxes[start_col][i] = nil
    end
    --append temp table one by one onto end_col
    for i = 1, #boxes_to_move do
        boxes[end_col][#boxes[end_col] + 1] = boxes_to_move[i]
    end
end

--iterate over the instructions and move the boxes
for i = 1, #raw_instructions do
    local instruction = parse_instruction(raw_instructions[i])
    move_multiple_boxes(instruction[1], instruction[2], instruction[3])
end

--find top boxes and print answer
top_boxes = {}
for i = 1, #boxes do
  table.insert(top_boxes, boxes[i][#boxes[i]])
end

print('final top boxes part 2:', table.concat(top_boxes))

--whole script runs in 0.06 seconds