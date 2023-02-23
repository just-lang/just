module Just
"""
parser functionality for the Just language
"""

    import JSON

    """read source file as string"""
    function read_src(src_file)
        source = read(src_file, String)
        return source
    end

    """read tokens file"""
    function read_tokens(tokens_file)
        # tokens = read(tokens_file, String)
        return tokens
    end

    """takes the raw source code and extracts tokens and thier functionality"""
    function lexer(source, tokens)
        # splits by lines
        src_lines = split(source, "\n")
        for line in src_lines
            # ignore comment lines
            if first(line) != "#"

            end
        end
    end

    """takes the token list from the lexer and produce an abstract syntax tree"""
    function parser()
            
    end

end # module Just
