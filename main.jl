
include("read_map_file.jl")
include("show_map.jl")
include("dijkstra.jl")
include("AStar.jl")

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

    map = read_map_file(file)

    start_point::Tuple{Int64, Int64} = (150, 100) 
    end_point::Tuple{Int64, Int64} = (853,926) 

    result1::Tuple{Vector{Tuple{Int64, Int64}},Vector{Tuple{Int64, Int64}}} = ([], [])
    result2::Tuple{Vector{Tuple{Int64, Int64}},Vector{Tuple{Int64, Int64}}} = ([], [])

    @time result1 = dijkstra(map, start_point, end_point)
    @time result2 = AStar(map, start_point, end_point)

    show_map(map, result1[1], result1[2])
    show_map(map, result2[1], result2[2])
end
