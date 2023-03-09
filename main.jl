
include("read_map_file.jl")
include("show_map.jl")
include("dijkstra.jl")

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
    start_point::Tuple{Int64, Int64} = (10,10) 

    # coodinate of the end point
    end_point::Tuple{Int64, Int64} = (34,34) 

    result::Tuple{Vector{Tuple{Int64, Int64}},Vector{Tuple{Int64, Int64}}} = ([], [])


    result = dijkstra(map, start_point, end_point)
    show_map(map, result[1], result[2])

end
