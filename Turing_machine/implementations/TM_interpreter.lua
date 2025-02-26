#!/bin/lua

-- Turing Machine description:

-- A .tm file specifies first the initial tape (line starting with '|') and then the instruction(s). Empty lines and comments are ignored.
-- The tape, made of cells, grows at both ends when needed. A cell can contain a space (default value), digit, letter or some other symbol.
-- An instruction consists of 5 characters: <current state check><current cell value check><new cell value><tape movement><new state>.
-- A state is noted by a digit, letter or some other symbol. Starting state is '0'. Stop state is '$'. States help with steps in your code.
-- Movement can be 'L' for left, 'R' for right and ' ' for staying still.
-- Execution resumes from the start once an instruction is performed (passed the two checks and new state isn't '$') or stops otherwise.


-- Interpreter:

function main()
    if #arg == 0 then
        print("Warning: no .tm file given as argument! Nothing to interpret.")
        return
    end
    
    local valid_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    valid_chars = valid_chars .. "0123456789 ~!@$%^&*()-_+={[}]\\;'\"<,>.?/"
    local default_cell = " "
    local default_state = "0"
    local stop_state = "$"
    local left = "L"
    local right = "R"
    local stay = " "
    local comment_char = "#"
    local tape_char = "|"
    local debug = false
    
    local tape, instructions = parse(arg[1], tape_char, comment_char, valid_chars, valid_chars, left .. right .. stay)
    interpret(tape, tape_char, instructions, default_state, stop_state, default_cell, left, right, stay, debug)
end


function parse(TM_file, tape_char, comment_char, valid_states, valid_cells, valid_moves)
    local tape = ""
    local instructions = {}
    local tape_found = false
    local instruction_found = false
    
    assert(io.open(TM_file, "r"))
    for line in io.lines(TM_file) do
        if string.len(line) ~= 0 and string.sub(line, 1, 1) ~= comment_char then
            if string.sub(line, 1, 1) == tape_char then
                
                -- tape handling
                if tape_found == false and instruction_found == false then
                    tape = string.sub(line, 2, string.len(line))
                    tape_found = true
                else
                    exit_custom_error("the initial tape can be specified only once and before any instruction")
                end
                
            else
                
                -- instruction handling
                local instruction = {}
                for i = 1, string.len(line) do
                    instruction[i] = string.sub(line, i, i)
                end
                
                -- instruction validation
                if #instruction == 5 then
                    if string.find(valid_states, instruction[1]) ~= nil and string.find(valid_states, instruction[5]) ~= nil then
                        if string.find(valid_cells, instruction[2]) ~= nil and string.find(valid_cells, instruction[3]) ~= nil then
                            if string.find(valid_moves, instruction[4]) ~= nil then
                                table.insert(instructions, instruction)
                                instruction_found = true
                            else
                                exit_custom_error("instruction contains an invalid <tape movement>")
                            end
                        else
                            exit_custom_error("instruction contains either an invalid <current cell value check> or invalid <<new cell value>")
                        end
                    else
                        exit_custom_error("instruction contains either an invalid <current state check> or invalid <new state>")
                    end
                else
                    exit_custom_error("instruction must be exactly 5 characters long")
                end
                
            end
        end
    end
    
    return tape, instructions
end


function interpret(tape, highlight_char, instructions, default_state, stop_state, default_cell, left, right, stay, debug)
    local current_tape_pos = 1
    local current_state = default_state
    
    if string.len(tape) == 0 then
        tape = tape .. default_cell
    end
    
    print(tape_repr(tape, "start  :", current_tape_pos, highlight_char, ":") .. " state :" .. current_state .. ":")
    if debug then
        print("")
    end
    
    while #instructions ~= 0 do
        local instruction_found = false
        
        for i = 1, #instructions do
            if instructions[i][1] == current_state then
                if instructions[i][2] == string.sub(tape, current_tape_pos, current_tape_pos) then
                    
                    if debug then
                        print(tape_repr(tape, "before :", current_tape_pos, highlight_char, ":") .. " state :" .. current_state .. ":")
                        print("\t" .. instructions[i][1] .. instructions[i][2] .. instructions[i][3] .. instructions[i][4] .. instructions[i][5])
                    end
                    
                    tape = string.sub(tape, 1, current_tape_pos - 1) .. instructions[i][3] .. string.sub(tape, current_tape_pos + 1, string.len(tape))
                    if string.find(left, instructions[i][4]) ~= nil then
                        if current_tape_pos ~= 1 then
                            current_tape_pos = current_tape_pos - 1
                        else
                            tape = default_cell .. tape
                        end
                    end
                    if string.find(right, instructions[i][4]) ~= nil then
                        if current_tape_pos == string.len(tape) then
                            tape = tape .. default_cell
                        end
                        current_tape_pos = current_tape_pos + 1
                    end
                    current_state = instructions[i][5]
                    
                    if debug then
                        print(tape_repr(tape, "after  :", current_tape_pos, highlight_char, ":") .. " state :" .. current_state .. ":")
                    end
                    
                    instruction_found = true
                    break
                end
            end
        end
        
        if current_state == stop_state then
            break
        end
        if instruction_found == false then
            print("\tWarning: no instruction found for state '" .. current_state .. "' and cell value '" .. string.sub(tape, current_tape_pos, current_tape_pos) .. "'!")
            break
        end
    end
    
    if debug then
        print("")
    end
    print(tape_repr(tape, "finish :", current_tape_pos, highlight_char, ":") .. " state :" .. current_state .. ":")
end


function tape_repr(tape, prefix, highlight_index, highlight_char, suffix)
    local repr = string.sub(tape, 1, highlight_index - 1) .. highlight_char .. string.sub(tape, highlight_index, highlight_index) .. highlight_char
    repr = prefix .. repr .. string.sub(tape, highlight_index + 1, string.len(tape)) .. suffix
    
    return repr
end


function create_custom_error_function()
    local exit_value = 0
    
    local function custom_error(err_msg)
        print("Error: " .. err_msg .. "!")
        exit_value = exit_value + 1
        print(exit_value)
        os.exit(exit_value)
    end
    
    return custom_error
end


exit_custom_error = create_custom_error_function()
main()
