-- comment 

--> 
multiline comment 
another one 
local assignment <const> = 5 
<-- 

ref <const> = 1 

local character <const> = 'c' 
local string <const> = "string" 
local multiline_string <const> = """ 
multiline string 
""" 

function add(a, b) 
    return a + b 
end 

function bigger(a, b) 
    local answer = false 
    if a > b 
        local answer <const> = true 
    else 
        local answer <const> = false 
    end 
    
    return answer 
end 

for fruit in {"apple","orange","pear"} 
    print(fruit) 
end 
