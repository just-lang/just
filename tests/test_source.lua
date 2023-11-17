-- comment

--[[
multiline comment
another one
assignment = 5
]]

character = 'c'
local string = "string"
local multiline_string = [[
multiline string
]]

local cnt = 1
var = "globe"

-- 5 != 6

function add(a, b)
    return a + b
end

function bigger(a, b)
    local answer = false
    if a > b then
        local answer = true
    else
        local answer = false
    end
    
    return answer
end

for i, fruit in pairs({"apple","orange","pear"}) do
    print(fruit)
end
