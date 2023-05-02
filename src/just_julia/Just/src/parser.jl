"""
parses the lexers output into abstract syntaxt tree for the Just language
"""

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