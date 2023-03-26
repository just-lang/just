"""
testing lexer function
"""

source_path = @__DIR__
project_dir = source_path[1:end-length("test/")]

using Pkg
Pkg.activate(project_dir)

include(joinpath(project_dir, "src", "lexer.jl"))
token_file = joinpath(project_dir, "src", "tokens.json")

function main(token_file)

    source_file = joinpath(project_dir, "test", "test_source.just")

    source_code = read(source_file, String)

    token_df = lexer(source_code, token_file)

    return token_df

end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
