-- Define a module table
local syntax_rules = {}


function syntax_rules.negation_rule(line, loc, context)
    line = slice(line, 1, loc-1) .. '~' .. slice(line, loc+1, length(line))
    loc = loc + 1
    return line, loc, context
end

function syntax_rules.character_rule(line, loc, context)
    if slice(line, loc+2, loc+2) ~= '\'' then
        error("single quote sign indicates a single character")
    end
    loc = loc + 3
    return line, loc, context
end

function syntax_rules.string_rule(line, loc, context)
    context = "string"
    if slice(line, loc+1, loc+2) == "\"\"" then
        line = slice(line, 1, loc-1) .. "[[" .. slice(line, loc+3, length(line))
        loc = loc + 3
        line, loc, context = multiline_string_rule(line, loc, context)
    else
        while loc < length(line) do
            if slice(line, loc, loc) == '\"' then
                context = "code"
                break
            end
            loc = loc + 1
        end
        if context == "string" then
            error("single double quotation indicates a single line string")
        end
    end
    loc = loc + 1
    return line, loc, context
end

function syntax_rules.multiline_string_rule(line, loc, context)
    while loc < length(line) do
        if slice(line, loc, loc+2) == "\"\"\"" then
            line = slice(line, 1, loc-1) .. "]]" .. slice(line, loc+3, length(line))
            context = "code"
            break
        end
        loc = loc + 1
    end
    loc = loc + 1
    return line, loc, context
end

function syntax_rules.comment_rule(line, loc, context)
    if slice(line, loc+1, loc+1) == '-' then
        context = "comment"
        if slice(line, loc+2, loc+2) == ">" then
            line = slice(line, 1, loc+1) .. "[[" .. slice(line, loc+3, length(line))
            loc = loc + 4
            line, loc, context = multiline_comment_rule(line, loc, context)
        else
            loc = length(line)
            context = "code"
        end
    end
    loc = loc + 1
    return line, loc, context
end

function syntax_rules.multiline_comment_rule(line, loc, context)
    while loc < length(line) do
        if slice(line, loc, loc+2) == "<--" then
            line = slice(line, 1, loc-1) .. "]]" .. slice(line, loc+3, length(line))
            context = "code"
            break
        end
        loc = loc + 1
    end
    loc = loc + 1
    return line, loc, context
end

function syntax_rules.assignment_rule(line, loc, context)
    if slice(line, loc-1, loc-1) == " " and slice(line, loc+1, loc+1) == " " then
        -- not implemented yet
    end
    loc = loc + 1
    return line, loc, context
end


-- Export the module
return syntax_rules