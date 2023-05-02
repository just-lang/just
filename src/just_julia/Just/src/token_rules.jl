"""
tokenization rules for the Just language
"""

"""source token type"""
struct SourceToken
    source::String
    type::String
    loc_start::Int
    loc_end::Int
end

"""reading token file"""
function get_tokens(token_file)
    token_text = read(token_file, String)
    token_dict = JSON.parse(token_text)
    return token_dict
end

"""tokenizing words"""
function word_tokens(word, token_dict)
    token = nothing
    for reserved_syntax in token_dict
        if word in reserved_syntax[2]["word"]
            token = reserved_syntax[1]
            break
        else
            token = "variable"
        end
    end
    return token
end

"""tokenizing symbols"""
function symbol_tokens(symbol, token_dict)
    token = nothing
    for reserved_syntax in token_dict
        if symbol in reserved_syntax[2]["symbol"]
            token = reserved_syntax[1]
            break
        end
    end
    if isnothing(token)
        throw("Syntax error: $symbol not supported")
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
