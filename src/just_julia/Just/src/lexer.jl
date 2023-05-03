"""
defining lexical token analizer for the Just programming language
"""

import JSON

include("syntax_rules.jl")
include("token_rules.jl")

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

    entities = Array{SourceEntity, 1}()

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

        entity = func(source, loc)
        if !isnothing(entity)
            push!(entities, entity)
            loc = entity.loc_end
        end

        loc += 1
    end

    return entities
end


"""takes entity_df and decode entities into tokens"""
function entity_to_token(entities, token_file)
    type_to_func = Dict(
        "word" => word_tokens,
        "symbol" => symbol_tokens,
        "numeric" => numeric_tokens
    )

    tokens = Array{SourceToken, 1}()

    token_dict = get_tokens(token_file)
    for entity in entities
        if entity.identity in keys(type_to_func)
            func = type_to_func[entity.identity]
            token_type = func(entity.source, token_dict)
            if isnothing(token_type)
                throw("Syntax error: $(entity.source) not supported")
            end
            token = SourceToken(
                entity.source,
                token_type,
                entity.loc_start,
                entity.loc_end
            )
        else
            token = SourceToken(
                entity.source,
                entity.identity,
                entity.loc_start,
                entity.loc_end
            )
        end
        push!(tokens, token)
    end

    return tokens
end


"""takes the raw source code and extracts tokens and thier locations"""
function lexer(source_code, token_file)
    entities = entity_recognition(source_code)
    tokens = entity_to_token(entities, token_file)
    return tokens
end

