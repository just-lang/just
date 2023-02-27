"""
defining lexical token analizer for the Just language
"""

using DataFrames, CSV

#=
    goes over each character in source
    identifies tokens in the source

    identation rules:
        allow either tab or 4 spaces
        when encounter 'space':
            if all 3 trailing chars are 'space' mark indent
            if not and last is indent or beginning of line, disallow
            if not allow only one 'space'

    comment rules:
        if encounter #>:
            search for the next <# and mark the whole section as multiline comment
        if encounter #:
            search for the next \n and mark the whole line as comment line

    character rule:
        when encounter ':
            allow single char in betweem next '.
    
    string rules:
        when encounter ":
            chack for multiline """:
                search for the next """ and mark the whole section as multiline string
            search for the next " and mark the whole section as string
            if encounter \n disallow
=#


"""identifies identation sections"""
function identation_rules(source, loc)
    if source[loc:loc+2] == "   "
        ends_at = loc+2
        token = source[loc:ends_at]
        token_loc = loc:ends_at
    else
        token = nothing
        token_loc = nothing
    end
    return token, token_loc
end

"""identifies comment sections"""
function comment_rules(source, loc)
    if source[loc+1] == '>'
        ends_at = last(findnext("<#", source, loc))
    else
        ends_at = last(findnext("\n", source, loc))
    end

    token = source[loc:ends_at]
    token_loc = loc:ends_at
    return token, token_loc
end

"""identifies character"""
function character_rules(source, loc)
    ends_at = loc+2
    if source[ends_at] == '\''
        token = source[loc:ends_at]
        token_loc = loc:ends_at
    else
        token = nothing
        token_loc = nothing
    end

    return token, token_loc
end

"""identifies string sections"""
function string_rules(source, loc)
    if source[loc:loc+2] == "\"\"\""
        ends_at = last(findnext("\"\"\"", source, loc+2))
    else
        ends_at = findnext('\"', source, loc+1)
    end

    token = source[loc:ends_at]
    token_loc = loc:ends_at
    return token, token_loc
end

"""identifies numerics"""
function numeric_rules(source)
    
end

"""identifies reserved words"""
function reserved_words_rules(source)
    
end


"""takes the raw source code and extracts tokens and thier locations"""
function lexer(source)#, tokens)
    
    stop_at_char = Dict(
        ' ' => identation_rules,
        '#' => comment_rules,
        '\'' => character_rules,
        '\"' => string_rules,
        # r"[0-9]" => numeric_rules,
        # collect('A':'z') => reserved_words_rules
    )

    tokenized_df = DataFrame(
        type = Array{String, 1}(),
        token = Array{String, 1}(),
        location = Array{UnitRange{Int64}, 1}()
    )

    loc = 1
    # for (loc, char) in enumerate(source)
    while loc <= length(source)
        char = source[loc]
        if char in keys(stop_at_char)
            # runs relevant rule function to each stop char
            func = stop_at_char[char]
            func_name = String(Symbol(func))
            token, token_loc = func(source, loc)
            if !any(isnothing.([token, token_loc]))
                token_type = replace(func_name, "_rules" => "")
                push!(tokenized_df, (token_type, token, token_loc))
                loc = last(token_loc)
            end
        end

        loc += 1
    end

    return tokenized_df
end

