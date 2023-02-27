"""
definning the tokens for the syntax parser 
"""

source_path = @__DIR__
project_dir = source_path[1:end-length("src/")]

using Pkg
Pkg.activate(project_dir)

import JSON

token_dict = Dict(
    "operator" => ["+","-","*","/","^"],
    "seperator" => ["(",")","[","]","{","}"],
    "variable" => [],
    "integer" => [],
    "float" => [],
    "boolean" => ["true", "false"],
    "string" => [],
    "character" => []
)


json_string = JSON.json(token_dict)

target_file = joinpath(source_path, "tokens.json")
open(target_file,"w") do file
    JSON.print(file, json_string)
end
