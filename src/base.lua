-- Define a module table
local base = {}

-- local lfs = require("lfs")

function base.using(source)
    module = require(source)
    for name,func in pairs(module) do
        _G[name] = func
    end
end

local function repeat_string(str, n)
    local result = ""
    for i = 1, n do
        result = result .. str
    end
    return result
end

local function show_table(table, indent_level)
    indent_level = indent_level or 0
    local indent = repeat_string(" ", 4)
    local current_indent = repeat_string(indent, indent_level)
    print(current_indent .. "{")
    indent_level = indent_level + 1
    local current_indent = repeat_string(indent, indent_level)
    for key, value in pairs(table) do
        if type(value) ~= "table" then
            print(current_indent .. key .. " = " .. value)
        else
            print(current_indent .. key .. " = ")
            show_table(value, indent_level)
        end
    end
    indent_level = indent_level - 1
    local current_indent = repeat_string(indent, indent_level)
    print(current_indent .. "}")
end

function base.show(object)
    if type(object) ~= "table" then
        print(object)
    else
        show_table(object)
    end
end

function base.length(table)
    local len = #table
    return len
end

local function in_table(element, some_table)
    local answer = false
    for _, value in pairs(some_table) do
        if value == element then
            answer = true
        end
    end
    return answer
end

local function in_string(element, some_string)
    local answer = false
    if string.find(some_string, element) then
        answer = true
    else
        answer = false
    end
    return answer
end

function base.occursin(element, source)
    local answer = false
    if type(source) == "table" then
        answer = in_table(element, source)
    elseif type(source) == "string" then
        answer = in_string(element, source)
    else
        print("unsupported type given")
        return
    end
    return answer
end

local function copy_table(table)
    local new_copy = {}
    for key, value in pairs(table) do
        if type(value) == "table" then
            new_copy[key] = copy_table(value)
        else
            new_copy[key] = value
        end
    end
    return new_copy
end

function base.copy(source)
    if type(source) == "table" then
        new_copy = copy_table(source)
    else
        new_copy = source
    end
    return new_copy
end

function base.empty(reference)
    local new_var

    if type(reference) == "number" then
        new_var = 0 -- Initialize as a number
    elseif type(reference) == "string" then
        new_var = "" -- Initialize as a string
    elseif type(reference) == "table" then
        new_var = {} -- Initialize as a table
    end

    return new_var
end

local function slice_table(source, start_index, end_index)
    local result = {}
    for i = start_index, end_index do
        if source[i] then
            table.insert(result, source[i])
        else
            error("ERROR: index is out of range")
            break
        end
    end
    return result
end

local function slice_string(source, start_index, end_index)
    return source:sub(start_index, end_index)
end

function base.slice(source, start_index, end_index)
    if type(source) == "table" then
        result = slice_table(source, start_index, end_index)
    elseif type(source) == "string" then
        result = slice_string(source, start_index, end_index)
    else
        error("ERROR: can't slice element of type: " .. type(source))
    end
    return result
end

function base.reverse(input)

    if type(input) == "string" then
        reversed = ""
        -- Reverse a string
        for i = #input, 1, -1 do
            reversed = reversed .. string.sub(input, i, i)
        end
    elseif type(input) == "table" then
        reversed = {}
        -- Reverse a table
        for i = #input, 1, -1 do
            table.insert(reversed, input[i])
        end
    else
        error("Unsupported type for reversal")
    end

    return reversed
end

-- function base.readdir(directory)
--     directory = directory or "."
--     local files = {}
--     for file in lfs.dir(directory) do
--         if file ~= "." and file ~= ".." then
--             table.insert(files, file)
--         end
--     end
--     return files
-- end

-- Export the module
return base