-- Define a module table
local just = {}

function just.using(source)
    module = require(source)
    for name,func in pairs(module) do
        _G[name] = func
    end
end

function just.length(table)
    local len = #table
    return len
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

function just.copy(source)
    if type(source) == "table" then
        new_copy = copy_table(source)
    else
        new_copy = source
    end
    return new_copy
end

function just.empty(reference)
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

function just.slice(source, start_index, end_index)
    if type(source) == "table" then
        result = slice_table(source, start_index, end_index)
    elseif type(source) == "string" then
        result = slice_string(source, start_index, end_index)
    else
        error("ERROR: can't slice element of type: " .. type(source))
    end
    return result
end

-- Export the module
return just