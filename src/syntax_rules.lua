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

function revesre_index(index, max)
    rev_ind = max - index + 1
    return rev_ind
end

function syntax_rules.assignment_rule(line, loc, context)
    local space_before_index = loc-1
    local space_before = slice(line, loc-1, loc-1) == ' '
    local space_after = slice(line, loc+1, loc+1) == ' '
    if space_before and space_after then
        start_search = revesre_index(space_before_index, length(line)) + 1
        reverse_line = reverse(line)

        find_result = string.find(reverse_line, " ", start_search)
        if find_result and string.find(reverse_line, "[a-z]", start_search) then
            end_of_word = revesre_index(find_result, length(line)) - 1
            start_search = find_result + 1
        else
            end_of_word = revesre_index(start_search - 1, length(line))
            start_search = length(line)
        end

    
        start_of_word = revesre_index(string.find(reverse_line, " ", start_search) or length(line), length(line))

        word = slice(line, start_of_word, end_of_word)

        if word then
            if word == "global" then
                line, loc = delete_word(word, start_of_word, end_of_word, line, loc)
            --     space_before_index = string.find(line, " = ")
            --     line, loc = add_word(" <const>", space_before_index, line, loc)
            -- elseif word == "mutable" then
            --     line, loc = delete_word(word, start_of_word, end_of_word, line, loc)
            --     line, loc = add_word("local ", start_of_word, line, loc)
            else
                line, loc = add_word("local ", start_of_word, line, loc)
            end
        else
            line, loc = add_word("local ", start_of_word, line, loc)
            -- space_before_index = string.find(line, " = ")
            -- line, loc = add_word(" <const>", space_before_index, line, loc)
        end
    end
    loc = loc + 1
    return line, loc, context
end

function delete_word(word, start_of_word, end_of_word, line, loc)
    line = slice(line, 1, start_of_word-1) .. slice(line, end_of_word+2, length(line))
    loc = loc - length(word)
    return line, loc
end

function add_word(word, start_of_word, line, loc)
    line = slice(line, 1, start_of_word-1) .. word .. slice(line, start_of_word, length(line))
    loc = loc + length(word)
    return line, loc
end

-- Export the module
return syntax_rules