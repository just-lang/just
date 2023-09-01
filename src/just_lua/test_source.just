-- comment

-->
multiline comment
another one
<--

character = 'c'
string = "string"
multiline_string = """
multiline string
"""

function add(a, b)
    return a + b
end

function bigger(a, b)
    mutable answer = false
    if a > b  begin
        answer = true
    else
        answer = false
    end
    
    return answer
end

for fruit in {"apple","orange","pear"}
    print(fruit)
end
