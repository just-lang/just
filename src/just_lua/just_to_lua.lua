local length = require("just").length
-- local copy = require("just").copy

local function get_indentations(line)
    local leading_spaces = line:match("^%s*")
    return leading_spaces or ""  -- If no spaces are found, return an empty string
end

-- Function to process a source line
local function process_line(line)
    local indentations = get_indentations(line)

    -- Split the line into words
    local words = {}
    for word in line:gmatch("%S+") do
        table.insert(words, word)
    end

    -- Process each word
    local processed_line = indentations
    local global = false
    local mutable = false

    for i, word in ipairs(words) do
        -- Check for qualifiers
        if word == "global" then
            global = true
        elseif word == "mutable" then
            mutable = true
        elseif i < #words and words[i + 1] == "=" then
            -- If it's an assignment and 'global' wasn't found, add 'local'
            if not global and not mutable then
                processed_line = processed_line .. "local "
            elseif mutable and global then
                error("ERROR: Can't assign a global variable as mutable")
            end
            processed_line = processed_line .. word .. " "
        else
            -- Otherwise, keep the word as is
            processed_line = processed_line .. word .. " "
        end
    end

    return processed_line
end

-- Function to get command line arguments
local function get_args()
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
local function main()
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
    for line in input_file:lines() do
        local processed_line = process_line(line)
        output_file:write(processed_line .. "\n")
    end

    -- Close both input and output files
    input_file:close()
    output_file:close()
end

-- Call the main function
main()
