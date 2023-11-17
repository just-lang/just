-- [x] TODO: add context to each line (code, string or comment)
-- [x] TODO: replace ~ with !
-- [x] TODO: multiline string [[\n]] with """\n"""
-- [x] TODO: multiline comment --[[\n]] with -->\n<--
-- [] TODO: assignment add-ons like mutablity and locality
-- [] TODO: 'if' without 'then', 'for'/'while' without 'do'


-- function get_script_path()
--     local info = debug.getinfo(1, "S")
--     local script_path = info.source:sub(2) -- Remove the '@' character at the beginning
--     return script_path:match("(.*/)") or "./"
-- end

-- local script_path = get_script_path()
-- package.path = package.path .. ";" .. script_path

using = require("base").using
using("base")
using("syntax_rules")

-- stop_at_chars = require("syntax_rules").stop_at_chars

--[[
args = {
    ["in"] = "../tests/test_source.just",
    ["out"] = "../tests/test_source.lus"
}
]]


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

    stop_at_chars = {
        ['!'] = negation_rule,
        ['-'] = comment_rule,
        ["'"] = character_rule,
        ['"'] = string_rule,
        ['='] = assignment_rule
    }

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