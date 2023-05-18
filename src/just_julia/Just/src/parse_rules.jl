"""
parsing rules for the Just programming language
"""

include("parser.jl")

#=
"""checks assigned type to data"""
function type_checker(token, type)
    
end
=#

"""maps key words to parsing rules"""
function get_func_map()
    func_map = Dict(
        "function" => parse_function_def,
        "type" => parse_assignment,
        "mutable" => parse_assignment,
        "for" => parse_for,
        "while" => parse_while,
        "if" => parse_if_else
    )

    return func_map
end    

"""parse function parameters in definition"""
function parse_function_params(tokens, current)
    reference = current

    lang_syntax = get_lang_syntax(token_dict)
    own = true
    cnt = 1
    sep = false # expects a seperator
    func_params = Array{Dict,1}()
    param = Dict{String, Any}()
    while tokens[reference+cnt].source != ")"
        if tokens[reference+cnt].source == ";"
            own = false
            cnt += 1
            sep = false
            continue
        end

        param["own"] = own

        if sep & (tokens[reference+cnt].source == ",")
            sep = false
            cnt += 1
            continue
        elseif !sep & (tokens[reference+cnt].type != "type")
            throw("Syntax error: function expects parameters with type decleration")
        else
            param["type"] = tokens[reference+cnt].source
            cnt += 1
            if !sep & (tokens[reference+cnt].type != "variable")
                throw("Syntax error: function expects variable as parameter")
            else
                param["name"] = tokens[reference+cnt].source
                cnt += 1
                if tokens[reference+cnt].source == "="
                    cnt += 1
                    if in(tokens[reference+cnt].source).(lang_syntax)
                        throw("Syntax error: default value can not be assigned to reserved syntax")
                    else
                        param["default"] = tokens[reference+cnt].source
                        cnt += 1
                    end
                end
                sep = true
            end
        end
        push!(func_params, param)
    end
    current += cnt 
    return func_params, current
end

"""parse function header in definition"""
function parse_function_header(tokens, current, level)
    reference = current

    if tokens[reference+1].type != "variable"
        throw("Syntax error: ilegal function name")
    elseif tokens[reference+2].type != "capsulation"
        throw("Syntax error: function name must be followd by parentheses")
    end

    current += 2 # name + parentheses

    if tokens[reference+2].source != "()"
        func_params, current = parse_function_params(tokens, current)
        current += 1 # closing parentheses
    else
        func_params = Array{Dict,1}()
    end

    func_header = Dict{String, Any}(
        "type" => "function",      
        "name" => tokens[reference+1].source,
        "params" => func_params
    )

    level += 1

    return func_header, current, level
end

"""parse function closing in definition"""
function parse_function_end(tokens, current, level)
    return_values = []
    sep = false # expects a seperator
    while tokens[current].source != "\n"
        if !sep
            to_return = Dict(
                "type" => tokens[current].type,
                "name" => tokens[current].source
            )
            push!(return_values, to_return)
        end
        current += 1
    end
    current += 2

    level -= 1
    if tokens[current].type != "end"
        throw("Syntax error: function expects 'end' for closing")
    end

    return return_values, current, level
end

"""parses function definition structure"""
function parse_function_def(tokens, current, level)
    func_header, current, level = parse_function_header(tokens, current, level)
    # function body
    func_body = parser(tokens, current ,level, global_scope=false)

    func_end = parse_function_end(tokens, current, level)
    level -= 1

    function_def = func_header
    function_def["body"] = func_body
    function_def["return"] = func_end
end

"""parse variable assignment"""
function parse_assignment(tokens, current)
    reference = current

    if tokens[reference].source == "mutable"
        reference += 1
    end
    
    if tokens[reference].type != "type"
        throw("Syntax error: expects type for assignment")
    elseif tokens[reference+1].type != "variable"
        throw("Syntax error: expects variable name after type")
    elseif tokens[reference+2].source != "<-"
        throw("Syntax error: expects <- symbol after variable name")
    elseif tokens[reference+3].type != tokens[reference].source
        throw("Syntax error: variable doesn't match type passed")
    end

    assignment = Dict{String, Any}(
        "type" => "assignment",      
        "name" => tokens[reference+1].source,
        "value" => tokens[reference+3].source
    )

    current += 4

    return assignment, current
end

"""parse for loop structure"""
function parse_for(tokens, current, level, global_scope)
    reference = current

    if tokens[reference+1].type != "variable"
        throw("Syntax error: for expects variable name for iteration")
    elseif tokens[reference+2].source != "in"
        throw("Syntax error: for expects 'in' after variable name")
    end
    # chack fot iterable

    for_body = parser(tokens, current ,level, global_scope)

    corrent += 1
    if tokens[current].type != "end"
        throw("Syntax error: function expects 'end' for closing")
    end
    
    # for_structure = func_header
    for_structure["body"] = for_body

    return for_structure
end

"""parse while loop structure"""
function parse_while(tokens, current, level)
    # if,condition -> close with end
end

"""parse if else structure"""
function parse_if_else(tokens, current, level)
    # if,condition -> close with end
end