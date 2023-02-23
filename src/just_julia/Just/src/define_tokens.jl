"""
definning the tokens for the syntax parser 
"""
import JSON

token_dict = Dict(
    "operator" => ["+","-","*","/","^"],
    "seperator" => ["(",")","[","]","{","}"]
    "variable" => [],
    "integer" => [],
    "float" => [],
    "boolean" => ["true", "false"],
    "string" => [],
    "character" => []
)

json_string = JSON.json(token_dict)

open("tokens.json","w") do f
    JSON.print(f, json_string)
end
