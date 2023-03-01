
include("read_map_file.jl")
include("show_map.jl")


#= 
. - passable terrain : value = 1
G - passable terrain : value = 1
@ - out of bounds
O - out of bounds
T - trees (unpassable)
S - swamp (passable from regular terrain) : value = 3
W - water (traversable, but not passable from terrain) value = ∞
=#


function main(file::String) 
    # import map 
    map = read_map_file(file)

    empty_map::Matrix{String} = ["." "." "." "." ".";
                                "." "." "." "T" ".";
                                "." "." "T" "T" ".";
                                "." "." "." "." ".";
                                "." "." "." "." "."]

    # coodinate of the start point
    start_point::Tuple{Int64, Int64} = (4,4) 

    # coodinate of the end point
    end_point::Tuple{Int64, Int64} = (2,2) 

    show_map(map)
end
