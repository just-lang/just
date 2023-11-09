-- TODO: add context to each line (code, string or comment)
-- TODO: replace ~ with !
-- TODO: multiline string [[\n]] with """\n"""
-- TODO: multiline comment --[[\n]] with -->\n<--


length = require("base").length
copy = require("base").copy
empty = require("base").empty
slice = require("base").slice

function negation_rule(line, loc, context)
    line = slice(line, 1, loc-1) .. '~' .. slice(line, loc+1, length(line))
    loc = loc + 1
    return line, loc, context
end

function character_rule(line, loc, context)
    if slice(line, loc+2, loc+2) ~= '\'' then
        error("single quote sign indicates a single character")
    end
    loc = loc + 3
    return line, loc, context
end

function string_rule(line, loc, context)
    context = "string"
    if slice(line, loc+1, loc+2) == "\"\"" then
        line = slice(line, 1, loc-1) .. "[[" .. slice(line, loc+3, length(line))
        loc = loc + 3
        line, loc, context = multiline_string_rule(line, loc, context)
    else
        while loc < length(line) do
            if slice(line, loc, loc) == '\"' then
                context = "code"
                break
            end
            loc = loc + 1
        end
        if context == "string" then
            error("single double quotation indicates a single line string")
        end
    end
    loc = loc + 1
    return line, loc, context
end

function multiline_string_rule(line, loc, context)
    while loc < length(line) do
        if slice(line, loc, loc+2) == "\"\"\"" then
            line = slice(line, 1, loc-1) .. "]]" .. slice(line, loc+3, length(line))
            context = "code"
            break
        end
        loc = loc + 1
    end
    loc = loc + 1
    return line, loc, context
end

function comment_rule(line, loc, context)
    context = "comment"
    if slice(line, loc+1, loc+1) == '-' then
        if slice(line, loc+2, loc+2) == ">" then
            line = slice(line, 1, loc+1) .. "[[" .. slice(line, loc+3, length(line))
            loc = loc + 4
            line, loc, context = multiline_comment_rule(line, loc, context)
        else
            loc = length(line)
            context = "code"
        end
    end
    loc = loc + 1
    return line, loc, context
end

function multiline_comment_rule(line, loc, context)
    while loc < length(line) do
        if slice(line, loc, loc+2) == "<--" then
            line = slice(line, 1, loc-1) .. "]]" .. slice(line, loc+3, length(line))
            context = "code"
            break
        end
        loc = loc + 1
    end
    loc = loc + 1
    return line, loc, context
end

function assignment_rule(line, loc, context)
    if slice(line, loc-1, loc-1) == " " and slice(line, loc+1, loc+1) == " " then
        -- not implemented yet
    end
    loc = loc + 1
    return line, loc, context
end

stop_at_chars = {
    ['!'] = negation_rule,
    ['-'] = comment_rule,
    ["'"] = character_rule,
    ['"'] = string_rule
    -- ['='] = assignment_rule
}

-- Function to process a source line
function process_line(line ,context)
    loc = 1
    while loc < length(line) do
        current_char = slice(line, loc, loc)
        if context == "string" then
            line, loc, context = multiline_string_rule(line, loc, context)
        elseif context == "comment" then
            line, loc, context = multiline_comment_rule(line, loc, context)
        elseif stop_at_chars[current_char] ~= nil then 
            line, loc, context = stop_at_chars[current_char](line, loc, context)
        end
        loc = loc + 1
    end
    
    --[[
    -- Split the line into words
    local words = {}
    for word in line:gmatch("%S+") do
        table.insert(words, word)
    end

    -- Process each word
    processed_line = indentations
    local global = false
    local mutable = false

    for i, word in ipairs(words) do
        -- Check for qualifiers
        if word == "global" then
            global = true
        elseif word == "mutable" then
            mutable = true
        elseif i < length(words) and words[i + 1] == "=" then
            -- If it's an assignment and 'global' wasn't found, add 'local'
            if mutable and global then
                error("ERROR: Can't assign a global variable as mutable")
            end
            
            if not global then
                processed_line = processed_line .. "local "
            end
            
            if not mutable then
                processed_line = processed_line .. word .. " <const>" .. " "
            else
                processed_line = processed_line .. word .. " "
            end
        else
            -- Otherwise, keep the word as is
            processed_line = processed_line .. word .. " "
        end
    end
    ]]
    return line, context
end

-- Function to get command line arguments
function get_args()
    local args = {}
    -- Check if the user provided the input and output file names as command-line arguments
    if (length(arg) ~= 4) or (arg[1] ~= "--in") or (arg[3] ~= "--out") then
        print("Usage: lua local_formatter.lua --in input_file.lua --out output_file.lua")
        return
    else 
        args["in"] = arg[2]
        args["out"] = arg[4]
    end

    return args
end

-- Main function
function main()
    local args = get_args()

    -- Open the input file for reading
    local input_file = io.open(args["in"], "r")
    if not input_file then
        print("Failed to open the input file.")
        return
    end

    -- Open the output file for writing
    local output_file = io.open(args["out"], "w")
    if not output_file then
        print("Failed to open the output file.")
        input_file:close()
        return
    end

    -- Process each line of the input file
    context = "code"
    for line in input_file:lines() do
        local processed_line, context = process_line(line, context)
        output_file:write(processed_line .. "\n")
    end

    -- Close both input and output files
    input_file:close()
    output_file:close()
end

-- Call the main function
main()
