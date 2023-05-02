module Just
"""
parser functionality for the Just language
"""

    # converts source code in character level to tokens
    include("lexer.jl")

    # converts tokens level parsed source code to abstract syntax tree
    include("parser.jl")


end # module Just