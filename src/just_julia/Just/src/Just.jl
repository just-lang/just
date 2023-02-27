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

    """takes the token list from the lexer and produce an abstract syntax tree"""
    function parser()
            
    end

end # module Just