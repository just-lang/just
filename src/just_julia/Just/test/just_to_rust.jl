"""
converts just source file to rust source file
"""

source_path = @__DIR__
project_dir = source_path[1:end-length("test/")]

using Pkg
Pkg.activate(project_dir)

using ArgParse
import Just

function parse_commandline()
    options = ArgParseSettings()

    @add_arg_table options begin
        "--source"
            help = "path to source file"
            required = true
        "--target"
            help = "path to target file"
            required = true
        "--tokens"
            help = "path to token file"
            required = true
    end

    return parse_args(options)
end

function main()

    args = parse_commandline()

    source = read(args["source"], String)
    
    tokens = Just.read_tokens(args["tokens"])

    new_source = Just.replace_tokens(source, tokens)
   
    write(args["target"], new_source)
    
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end