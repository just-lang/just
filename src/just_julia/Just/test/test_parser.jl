"""
testing parser function
"""

source_path = @__DIR__
project_dir = source_path[1:end-length("test/")]

using Pkg
Pkg.activate(project_dir)

include(joinpath(project_dir, "src", "lexer.jl"))
include(joinpath(project_dir, "src", "parser.jl"))

function main()

    source_file = joinpath(project_dir, "test", "test_source.just")

    source_code = read(source_file, String)

    token_file = joinpath(project_dir, "src", "tokens.json")

    tokens = lexer(source_code, token_file)

    ast = parser(tokens)

    return ast

end

if abspath(PROGRAM_FILE) == @__FILE__
    print(main())
end
