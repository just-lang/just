x = 5
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

# function bigger(a,b)
#     if a > b  begin
#         bool answer <- true
#     else if b > a
#         bool answer <- false
#     else
#         string answer <- "equal"
#     end
    
#     return answer
# end

Dict{Any, Any}(
    "type" => "function",
    "name" => "bigger",
    "params" => [
        Dict{Any, Any}(
            "type" => "variable",
            "name" => "a",
            "default" => nothing
        ),
        Dict{Any, Any}(
            "type" => "variable",
            "name" => "b",
            "default" => nothing
        )
    ],
    "body" => [
        Dict{Any, Any}(
            "type" => "if",
            "condition" => Dict{Any, Any}(
                "type" => ">",
                "left" => Dict{Any, Any}(
                    "type" => "variable",
                    "name" => "a"
                ),
                "right" => Dict{Any, Any}(
                    "type" => "variable",
                    "name" => "b"
                )
            ),
            "body" => [
                Dict{Any, Any}(
                    "type" => "assignment",
                    "left" => Dict{Any, Any}(
                        "type" => "variable",
                        "name" => "answer",
                        "default" => nothing
                    ),
                    "right" => Dict{Any, Any}(
                        "type" => "bool",
                        "value" => true
                    )
                )
            ],
            "else_if" => [
                Dict{Any, Any}(
                    "type" => "if",
                    "condition" => Dict{Any, Any}(
                        "type" => ">",
                        "left" => Dict{Any, Any}(
                            "type" => "variable",
                            "name" => "b"
                        ),
                        "right" => Dict{Any, Any}(
                            "type" => "variable",
                            "name" => "a"
                        )
                    ),
                    "body" => [
                        Dict{Any, Any}(
                            "type" => "assignment",
                            "left" => Dict{Any, Any}(
                                "type" => "variable",
                                "name" => "answer",
                                "default" => nothing
                            ),
                            "right" => Dict{Any, Any}(
                                "type" => "bool",
                                "value" => false
                            )
                        )
                    ],
                    "else" => [
                        Dict{Any, Any}(
                            "type" => "assignment",
                            "left" => Dict{Any, Any}(
                                "type" => "variable",
                                "name" => "answer",
                                "default" => nothing
                            ),
                            "right" => Dict{Any, Any}(
                                "type" => "string",
                                "value" => "equal"
                            )
                        )
                    ]
                )
            ],
            "else" => nothing
        ),
        Dict{Any, Any}(
            "type" => "return",
            "value" => Dict{Any, Any}(
                "type" => "variable",
                "name" => "answer"
            )
        )
    ]
)
