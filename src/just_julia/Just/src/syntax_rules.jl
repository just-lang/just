"""
syntax rules for the Just programming language
"""

"""source entity type"""
struct SourceEntity
    source::String
    identity::String
    loc_start::Int
    loc_end::Int
end

# """deals with expected syntax occurences"""
# function expect_syntax(message::String)
#     println(message)
# end

"""identifies identation sections"""
function identation_rules(source, loc)
    indent_length = 4
    ends_at = loc + indent_length-1
    entity_loc = loc:ends_at
    if source[entity_loc] == repeat(" ",indent_length)
        entity = SourceEntity(
            source[entity_loc], # source::String
            "indentation", # identity::String
            loc, # loc_start::Int
            ends_at # loc_end::Int
        )
    else
        entity = nothing
    end
    return entity
end

"""identifies comment sections"""
function comment_rules(source, loc)
    if source[loc+1] == '>'
        ends_at = last(findnext("<#", source, loc))
        if isnothing(ends_at)
            throw("Syntax error: expects <# to end multiline comment")
        end
    else
        ends_at = last(findnext("\n", source, loc))
        if isnothing(ends_at)
            throw("Syntax error: expects a single trailing empty line at end of source file")
        end
    end

    entity_loc = loc:ends_at
    entity = SourceEntity(
        source[entity_loc], # source::String
        "comment", # identity::String
        loc, # loc_start::Int
        ends_at # loc_end::Int
    )
    return entity
end

"""identifies character"""
function character_rules(source, loc)
    ends_at = loc+2
    if (source[ends_at] == '\'') & isascii(source[loc+1])
        entity_loc = loc:ends_at
        entity = SourceEntity(
            source[entity_loc], # source::String
            "character", # identity::String
            loc, # loc_start::Int
            ends_at # loc_end::Int
        )
    else
        throw("Syntax error: single quote is reserved for a single acsii character")
    end
    return entity
end

"""identifies string sections"""
function string_rules(source, loc)
    if source[loc:loc+2] == "\"\"\""
        ends_at = last(findnext("\"\"\"", source, loc+2))
        if isnothing(ends_at)
            throw("Syntax error: expects \"\"\" to end multiline string")
        end
    else
        ends_at = findnext('\"', source, loc+1)
        new_line = findnext('\n', source, loc+1)
        if new_line < ends_at
            throw("Syntax error: expects double-quote to be on the same line")
        end
    end

    entity_loc = loc:ends_at
    entity = SourceEntity(
        source[entity_loc], # source::String
        "string", # identity::String
        loc, # loc_start::Int
        ends_at # loc_end::Int
    )
    return entity
end

"""identifies new_lines"""
function new_line_rules(source, loc)
    entity_loc = loc:loc
    entity = SourceEntity(
        source[entity_loc], # source::String
        "new_line", # identity::String
        loc, # loc_start::Int
        loc # loc_end::Int
    )
    return entity
end

"""identifies numerics"""
function numeric_rules(source, loc)
    ends_at = loc

    while isnumeric(source[ends_at]) | (source[ends_at] == '.')
        ends_at += 1
    end
    ends_at -= 1

    entity_loc = loc:ends_at
    entity = SourceEntity(
        source[entity_loc], # source::String
        "numeric", # identity::String
        loc, # loc_start::Int
        ends_at # loc_end::Int
    )
    return entity
end

"""identifies words"""
function word_rules(source, loc)
    ends_at = loc
    while occursin(r"[a-zA-Z0-9_]", "$(source[ends_at])")
        ends_at += 1
    end
    ends_at -= 1
    
    entity_loc = loc:ends_at
    entity = SourceEntity(
        source[entity_loc], # source::String
        "word", # identity::String
        loc, # loc_start::Int
        ends_at # loc_end::Int
    )
    return entity
end

"""identifies symbols"""
function symbol_rules(source, loc)
    ends_at = loc
    while !occursin(r"[a-zA-Z0-9_ \n]", "$(source[ends_at])")
        ends_at += 1
    end
    ends_at -= 1
    
    entity_loc = loc:ends_at
    entity = SourceEntity(
        source[entity_loc], # source::String
        "symbol", # identity::String
        loc, # loc_start::Int
        ends_at # loc_end::Int
    )
    return entity
end
