-- Define a module table
local just = {}

function just.length(table)
    local len = #table
    return len
end

local function copy_table(table)
    local copy = {}
    for key, value in pairs(table) do
        if type(value) == "table" then
            copy[key] = copy_table(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function just.copy(source)
    if type(source) == "table" then
        copy = copy_table(source)
    else
        copy = source
    end
    return copy
end

-- Export the module
return just