"""
parsing rules for the Just programming language
"""

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
    # variable with type definition
    # possibly assignment to default value 
    # (param::string="text")
    # (string param="text")
end

"""parse function header in definition"""
function parse_function_header(tokens, current, level)
    reference = current.copy()

    if tokens[reference+1].type != variable
        throw("Syntax error: ilegal function name")
    elseif tokens[reference+2].type != capsulation
        throw("Syntax error: function name must be followd by parentheses")
    end

    current += 2 # name + parentheses

    if tokens[current+2].source != "()"
        func_params, current = [parse_function_params(tokens, current)]
        current += 1 # closing parentheses
    else
        func_params = []
    end

    func_header = Dict(
        "type" => "function",      
        "name" => tokens[reference+1].source,
        "params" => func_params
    )

    level += 1

    return func_header, current, level
end

"""parse function closing in definition"""
function parse_function_close(tokens, current, level)
    # have to return certine type?
    # defining return variable?
    level -= 1

    return func_close, current, level
end

"""parses function definition structure"""
function parse_function_def(tokens, current, level)
    parse_function_header(tokens, current, level)
    level += 1
    # function body
    parse_function_close(tokens, current, level)
    level -= 1
end

"""parse variable assignment"""
function parse_assignment(tokens, current)
    # type,variable,assignment,data (of the same type) -> assignment
end

"""parse for loop structure"""
function parse_for(tokens, current, level)
    # if,condition -> close with end
end

"""parse while loop structure"""
function parse_while(tokens, current, level)
    # if,condition -> close with end
end

"""parse if else structure"""
function parse_if_else(tokens, current, level)
    # if,condition -> close with end
end