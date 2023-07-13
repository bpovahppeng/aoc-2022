require('library') -- my library functions

-- From a series of directions and distances, find the squares that the tail passes through
-- I have a feeling that part 2 will be modifying the distance that the tail can be from the head,
-- so, I will try to make this code work for any allowable distance from the start.
-- Just in case part 2 cares about the history of the head instead, I am also going to keep track of that from the start.

local raw_directions = read_txt('input/input_9.txt') -- load the input file

-- extract the distances and directions
local distances = {}
local directions = {} -- directions in the instructions are U, D, L, R

for i = 1, #raw_directions do
    distances[i] = extract_all(raw_directions[i], '%d+', 'number')[1]
    directions[i] = extract_all(raw_directions[i], '%a+', 'string')[1]
end

-- start defining the functions that will be used to move the head and tail
function move(object, direction)
    if direction == 'U' then
        object.y = object.y + 1
    elseif direction == 'D' then
        object.y = object.y - 1
    elseif direction == 'L' then
        object.x = object.x - 1
    elseif direction == 'R' then
        object.x = object.x + 1
    elseif direction == 'UL' then
        object.y = object.y + 1
        object.x = object.x - 1
    elseif direction == 'UR' then
        object.y = object.y + 1
        object.x = object.x + 1
    elseif direction == 'DL' then
        object.y = object.y - 1
        object.x = object.x - 1
    elseif direction == 'DR' then
        object.y = object.y - 1
        object.x = object.x + 1
    else
        print('Invalid direction')
    end
    return(nil)
end

function update_history(object)
    object.history[object.x..'-'..object.y] = true
    return(nil)
end

function get_distance(object1, object2)
    return(math.max(math.abs(object1.x - object2.x), math.abs(object1.y - object2.y)))
end

function tail_in_range(head, tail, rope_length)
    if get_distance(head, tail) <= rope_length then
        return(true)
    else
        return(false)
    end
end

function get_next_tail_direction(head, tail)
    local x_diff = head.x - tail.x
    local y_diff = head.y - tail.y

    local x_direction = ''
    local y_direction = ''

    if x_diff > 0 then
        x_direction = 'R'
    elseif x_diff < 0 then
        x_direction = 'L'
    end

    if y_diff > 0 then
        y_direction = 'U'
    elseif y_diff < 0 then
        y_direction = 'D'
    end

    return(y_direction..x_direction)

end

function process_instruction(head, tail, direction, distance, rope_length)
    
    for i = 1, distance do
        move(head, direction)
        update_history(head)
        if not tail_in_range(head, tail, rope_length) then
            move(tail, get_next_tail_direction(head, tail))
            update_history(tail)
        end
    end
end

function count_history(object)
    local count = 0
    for k, v in pairs(object.history) do
        count = count + 1
    end
    return(count)
end

-- initiate the head and tail as objects
local head = {x = 0, y = 0, history = {}} -- history is a table of all the coordinates visited
local tail = {x = 0, y = 0, history = {}}

-- store the starting coordinates in the history
update_history(head)
update_history(tail)

-- process the instructions
for i = 1, #distances do
    process_instruction(head, tail, directions[i], distances[i], 1)
end

print('head visited spaces: ', count_history(head))
print('tail visited spaces: ', count_history(tail)) --6332!

-- part 2, the rope now has many knots... instead of changing rope length, we need to simulate more objects

-- initiate the objects
local rope = {}
for i = 1, 10 do
    rope[i] = {x = 0, y = 0, history = {}}
    update_history(rope[i])
end

function process_instruction_part_2(rope, direction, distance)
    for i = 1, distance do
        for j = 1, #rope do
            if j == 1 then -- if the head, simply move in the direction
                move(rope[j], direction)
                update_history(rope[j])
            else -- if not the head, follow the same distance logic as part 1
                if not tail_in_range(rope[j - 1], rope[j], 1) then
                    move(rope[j], get_next_tail_direction(rope[j - 1], rope[j]))
                    update_history(rope[j])
                end
            end
            
        end
    end
end

-- process the instructions
for i = 1, #distances do
    process_instruction_part_2(rope, directions[i], distances[i])
end

print('tail visited spaces: ', count_history(rope[10])) -- 2511!