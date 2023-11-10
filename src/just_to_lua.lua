-- TODO: add context to each line (code, string or comment)
-- TODO: replace ~ with !
-- TODO: multiline string [[\n]] with """\n"""
-- TODO: multiline comment --[[\n]] with -->\n<--
-- TODO: assignment add-ons like mutablity and locality
-- TODO: 'if' without 'then', 'for'/'while' without 'do'


using = require("base").using
using("base")
using("syntax_rules")

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
        print("Usage: lua just_to_lua.lua --in input_file.lua --out output_file.lua")
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
        return
    end

    local log_file = io.open("log.txt", "w")
    if not log_file then
        print("Failed to open the log file.")
        return
    end

    -- Process each line of the input file
    context = "code"
    for line in input_file:lines() do
        processed_line, context = process_line(line, context)
        output_file:write(processed_line .. "\n")
        log_file:write(processed_line .. "    " .. context .. "\n")
    end

    -- Close both input and output files
    input_file:close()
    output_file:close()
    log_file:close()
end

-- Call the main function
main()

-- lua just_to_lua.lua --in test_source.just --out test_source.lua