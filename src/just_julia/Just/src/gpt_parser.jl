using Parsers, Base.Iterators

# Define the grammar for the language
const grammar = """
    statement      = comment | declaration | function
    comment        = "#" / [^\\n]*
    declaration    = type " " id "=" expr
    function       = "function" id "(" [args] ")" block "end"
    args           = id {"," id}
    block          = [statement ";" | expr ";"]*
    expr           = ifexpr | binary
    ifexpr         = "if" binary "then" block ["else if" binary "then" block]* ["else" block] "end"
    binary         = chainl1(atom, operator)
    atom           = variable | literal | "(" expr ")"
    variable       = id
    literal        = bool | int | float | string
    bool           = "true" | "false"
    int            = r"[+-]?\d+"
    float          = r"[+-]?\d+\.\d+"
    string         = "\"" r"(\"|\\[^\n]|[^\\\"\n])*\"" 
    char           = "'" r"([^'\\\n]|\\[^\n])*\'"
    operator       = "==" | "!=" | "<=" | ">=" | "<" | ">" | "+" | "-" | "*" | "/" | "^"
    type           = "int" | "float" | "bool" | "string"
    id             = r"[a-zA-Z_][a-zA-Z0-9_]*"
"""

# Define a function that parses a string into an AST
function parse_code(code::String)::Any
    # Parse the code using the grammar
    ast = parse(grammar, code)

    # Define a dictionary that maps node types to functions that build the corresponding AST node
    builders = Dict(
        "comment" => node -> nothing,
        "declaration" => node -> [:declaration, node[1], node[2], node[3]],
        "function" => node -> [:function, node[1], node[2], node[3]],
        "id" => node -> node.value,
        "bool" => node -> node.value == "true",
        "int" => node -> parse(Int, node.value),
        "float" => node -> parse(Float64, node.value),
        "string" => node -> node.value[2:end-1],
        "binary" => node -> [node[2], node[1], node[3]],
        "ifexpr" => node -> [:if, node[2:end-1], node[end]],
        "block" => node -> [:block, [build_ast(n) for n in node]],
        "variable" => node -> [:variable, node.value],
        "literal" => node -> build_ast(node[1]),
        "args" => node -> [build_ast(n) for n in node],
    )

    # Define a function that recursively builds an AST from a parsed node
    function build_ast(node)
        builder = builders[typeof(node)]
        builder(node)
    end

    # Build the AST from the parsed code
    return build_ast(ast)
end
