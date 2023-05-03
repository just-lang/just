"""
parses the lexers output into abstract syntaxt tree for the Just programming language
"""

include("parse_rules.jl")

function init_ast()
    ast = Dict(
        "Program" => Dict()
    )  
    return ast
end

# function add_branch(ast, ast_path, nodes)
#    
# end

function parser(tokens)
    ast = init_ast()
    func_map = get_func_map()
    
    for token in tokens
        if token.type in ["comment", "new_line"]
            # do nothing
        else
            # parse
        end
    end
end

# x=5
# {
#   "type": "assignment",
#   "target": {
#     "type": "identifier",
#     "name": "x"
#   },
#   "value": {
#     "type": "literal",
#     "value": 5
#   }
# }