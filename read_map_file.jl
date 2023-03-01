# on ouvre les fichiers maps
function read_map_file(path::String)
    # read file contents, one line at a time
    map_file = open(path)
    
    # read the parameters
    s = readline(map_file)

    s = readline(map_file)
    height = parse(Int64, split(s, " ")[2])

    s = readline(map_file)
    width = parse(Int64, split(s, " ")[2])

    s = readline(map_file)
 
    # initialize a matrix
    map = Array{String, 2}(undef, height, width)
    
    # read map till end of file
    line = 1
    while ! eof(map_file) 
        # read the next line for every iteration 
        s = readline(map_file)
        pattern = split(s, "")         
        for i in 1:width      
            map[line, i] = pattern[i] 
        end
        line += 1
    end
    return map
end

