"""
parses the lexers output into abstract syntaxt tree for the Just programming language
"""

include("parse_rules.jl")
include("lexer.jl")

source_path = @__DIR__
token_file = joinpath(source_path, "tokens.json")
token_dict = get_tokens(token_file)

function get_lang_syntax(token_dict)
    return vcat([vcat(t...) for t in values.(values(token_dict))]...)    
end

function init_ast()
    ast = Dict(
        "Program" => Dict()
    )  
    return ast
end

# function add_branch(ast, ast_path, nodes)
#    
# end

function parser(tokens, current=1 ,level=0, global_scope=true)
    if global_scope
        ast = init_ast()
    else
        ast = Dict()
    end

    func_map = get_func_map()
    
    for token in tokens
        if token.type in ["comment", "new_line"]
            # do nothing
        else
            # parse
        end
    end
end
