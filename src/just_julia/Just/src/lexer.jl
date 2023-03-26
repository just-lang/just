"""
defining lexical token analizer for the Just language
"""

using DataFrames
import JSON

"""identifies identation sections"""
function identation_rules(source, loc)
    ends_at = loc+3
    if source[loc:ends_at] == repeat(" ",4)
        token_loc = loc:ends_at
        token = source[token_loc]
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

    token_loc = loc:ends_at
    token = source[token_loc]
    return token, token_loc
end

"""identifies character"""
function character_rules(source, loc)
    ends_at = loc+2
    if source[ends_at] == '\''
        token_loc = loc:ends_at
        token = source[token_loc]
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

    token_loc = loc:ends_at
    token = source[token_loc]
    return token, token_loc
end

"""identifies new_lines"""
function new_line_rules(source, loc)
    token_loc = loc:loc
    token = "$(source[token_loc])"
    return token, token_loc
end


"""identifies numerics"""
function numeric_rules(source, loc)
    ends_at = loc

    while (isnumeric(source[ends_at]) | (source[ends_at] == '.')) & (ends_at <= length(source))
        ends_at += 1
    end
    ends_at -= 1

    token_loc = loc:ends_at
    token = source[token_loc]
    return token, token_loc
end

"""identifies words"""
function word_rules(source, loc)
    ends_at = loc
    while occursin(r"[a-zA-Z0-9_]", "$(source[ends_at])")
        ends_at += 1
    end
    ends_at -= 1
    
    token_loc = loc:ends_at
    token = source[token_loc]

    return token, token_loc
end

"""identifies symbols"""
function symbol_rules(source, loc)
    ends_at = loc
    while !occursin(r"[a-zA-Z0-9_ \n]", "$(source[ends_at])")
        ends_at += 1
    end
    ends_at -= 1
    
    token_loc = loc:ends_at
    token = source[token_loc]

    return token, token_loc
end

function prep_source(source)
    # remove trailing spaces
    source = strip(source)
    # padd source with space at the end
    source = join([source," "])
    return source
end

"""takes the raw source code and extracts entities and thier locations"""
function entity_recognition(source)
    
    source = prep_source(source)

    stop_at_char = Dict(
        ' ' => identation_rules,
        '#' => comment_rules,
        '\'' => character_rules,
        '\"' => string_rules,
        '\n' => new_line_rules
    )

    entity_df = DataFrame(
        type = Array{String, 1}(),
        entity = Array{String, 1}(),
        location = Array{UnitRange{Int64}, 1}()
    )

    loc = 1
    while loc < length(source)
        char = source[loc]
        if char in keys(stop_at_char)
            # runs relevant rule function to each stop char
            func = stop_at_char[char]
        elseif isletter(char)
            func = word_rules
        elseif isnumeric(char)
            func = numeric_rules
        else
            func = symbol_rules
        end

        func_name = String(Symbol(func))
        token, token_loc = func(source, loc)
        if !any(isnothing.([token, token_loc]))
            token_type = replace(func_name, "_rules" => "")
            push!(entity_df, (token_type, token, token_loc))
            loc = last(token_loc)
        end

        loc += 1
    end

    return entity_df
end


"""reading token file"""
function get_tokens(token_file)
    token_text = read(token_file, String)
    token_dict = JSON.parse(token_text)
    return token_dict
end

"""tokenizing words"""
function word_tokens(word, token_dict)
    reserved_words = ["type", "statement", "expression", "end"]
    token = nothing
    for res in reserved_words
        if word in token_dict[res]
            token = res
            break
        else
            token = "variable"
        end
    end
    return token
end

"""tokenizing symbols"""
function symbol_tokens(symbol, token_dict)
    reserved_symbols = ["equivalence", "assignment", "operator", "capsulator", "seperator"]
    token = nothing
    for res in reserved_symbols
        if symbol in token_dict[res]
            token = res
            break
        end
    end
    return token
end

"""tokenizing numerics"""
function numeric_tokens(numeric, token_dict)
    if occursin(".", numeric)
        token = "float"
    else
        token = "int"
    end
    return token
end

"""takes entity_df and decode entities into tokens"""
function entity_to_token(entity_df, token_file)
    type_to_func = Dict(
        "word" => word_tokens,
        "symbol" => symbol_tokens,
        "numeric" => numeric_tokens
    )

    token_df = DataFrame(
        type = Array{String, 1}(),
        token = Array{String, 1}(),
        location = Array{UnitRange{Int64}, 1}()
    )

    token_dict = get_tokens(token_file)
    for row in eachrow(entity_df)
        if row.type in keys(type_to_func)
            func = type_to_func[row.type]
            token = func(row.entity, token_dict)
            if isnothing(token)
                return "$(row.entity) not supported"
            else
                push!(token_df, (token, row.entity, row.location))
            end
        else
            row_df = rename(DataFrame(row), "entity" => "token")
            token_df = [token_df; row_df]
        end
    end

    return token_df
end


"""takes the raw source code and extracts tokens and thier locations"""
function lexer(source_code, token_file)
    entity_df = entity_recognition(source_code)
    tokens_df = entity_to_token(entity_df, token_file)
    return tokens_df
end
