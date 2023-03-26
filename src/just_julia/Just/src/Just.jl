module Just
"""
parser functionality for the Just language
"""

    import JSON

    include("lexer.jl")

    """read tokens file"""
    function read_tokens(tokens_file)
        tokens = JSON.parsefile(tokens_file)
        tokens = convert(Dict{String, String}, tokens)
        return tokens
    end

    """replaces all tokens in source"""
    function replace_tokens(source, tokens)
        new_source = replace(source, tokens...)
        return new_source
    end

    """replaces all tokens in source"""
    function translator(source, tokens_file)
        tokens = read_tokens(tokens_file)
        tokenized_source = lexer(source)
        new_source = ""
        for row in eachrow(tokenized_source)
            if row.type == "word"
                new_token = replace(row.token, tokens...)
                new_source *= new_token
            elseif row.type == "comment"
                # do nothing
            else
                new_source *= row.token
            end
        end
        return new_source
    end

    """takes the token list from the lexer and produce an abstract syntax tree"""
    function parser()
            
    end

end # module Just