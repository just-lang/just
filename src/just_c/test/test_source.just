# comment

#>
multiline comment
another one
<#

string some_string <- "string"
char some_character <- 'c'

function add(int a, int b)
    return a + b
end

string some_string2 <- """
multi line string
"""

function bigger(int a, int b)
    if a > b  begin
        bool answer <- true
    else if b > a
        bool answer <- false
    else
        string answer <- "equal"
    end
    
    return answer
end

for fruit in ["apple","orange","pear"]
    print(fruit)
end

function main()
    int x <- 5
    mutable int y <- 8.5
end
