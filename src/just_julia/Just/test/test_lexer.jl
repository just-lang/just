"""
testing lexer function
"""

import JSON

source_path = @__DIR__
project_dir = source_path[1:end-length("test/")]

using Pkg
Pkg.activate(project_dir)

include(joinpath(project_dir, "src", "lexer.jl"))
token_file = joinpath(project_dir, "src", "tokens.json")

function struct_to_dict(s)
    d = Dict(key => getfield(s, key) for key in propertynames(s))
    d_sorted = sort(collect(d), by = x->x[1], rev=true)
    return d_sorted
end

function get_tokens_dict(tokens)
    tokens_dict = Dict()

    for (index, token) in enumerate(tokens)
        tokens_dict[index] = struct_to_dict(token)
    end

    tokens_dict_sorted = sort(collect(tokens_dict), by = x->x[1])

    return tokens_dict_sorted    
end

function save_tokens(tokens, path)
    tokens_dict = get_tokens_dict(tokens)
    # json_string = JSON.json(tokens_dict)

    open(path,"w") do file
        JSON.print(file, tokens_dict)
    end
end

function main()

    source_file = joinpath(project_dir, "test", "test_source.just")

    source_code = read(source_file, String)

    token_file = joinpath(project_dir, "src", "tokens.json")

    tokens = lexer(source_code, token_file)

    save_tokens(tokens, joinpath(project_dir, "test", "test_source_tokend.json"))
    # return tokens

end

if abspath(PROGRAM_FILE) == @__FILE__
    print(main())
end
