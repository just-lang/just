-- comment

-->
multiline comment
another one
assignment = 5
<--

global ref = 1

character = 'c'
string = "string"
multiline_string = """
multiline string
"""

5 != 6

function add(a, b)
    return a + b
end

function bigger(a, b)
    mutable answer = false
    if a > b
        answer = true
    else
        answer = false
    end
    
    return answer
end

for fruit in {"apple","orange","pear"}
    print(fruit)
end
