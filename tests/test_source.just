-- comment

-->
multiline comment
another one
assignment = 5
<--

global character = 'c'
string = "string"
multiline_string = """
multiline string
"""

cnt = 1
global var = "globe"

function add(a, b)
    return a + b
end

function bigger(a, b)
    answer = false
    if a > b
        answer = true
    else
        answer = false
    end
    
    return answer
end

for ind, fruit in pairs({"apple","orange","pear"})
    print(fruit)
end
