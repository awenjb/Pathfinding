using DataStructures

include("read_map_file.jl")
include("show_map.jl")


# Manhattan distance
function heuristic(A::Tuple{Int64,Int64}, B::Tuple{Int64,Int64})
    return abs(B[1]-A[1]) + abs(B[2]-A[2])
end 

#= 
    Return the cost value of a cell which contains :
    a boolean, true if the cell is accessible, false otherwise
    an integer, cost of "traveling"
=#

function cost(map::Matrix{String}, cell::Tuple{Int64, Int64})

    # boolean -> passable or not
    # int -> cost of travel
    cost_value = Dict(  "@" => (false, 0), 
                        "T" => (false, 0), 
                        "O" => (false, 0), 
                        "." => (true,1),
                        "G" => (true,1), 
                        "S" => (true,5), 
                        "W" => (true,8)
    )

    # is out of bounds ?
    if cell[1] > size(map, 1) || cell[2] > size(map, 2) || cell[1] < 1 || cell[2] < 1
        return (false, 0) 
    end

    # type of the cell ( a character )
    c = map[cell[1], cell[2]]
    return cost_value[c]
end

#= 
    AStar Algorithm
    From a map, a starting point and a ending point, return the shortest path
=#
function WAStar(map::Matrix{String}, src::Tuple{Int64, Int64}, target::Tuple{Int64, Int64}, w::Float64)

    # Initialize 

    path::Vector{Tuple{Int64, Int64}} = []

    open = PriorityQueue{Tuple{Int64,Int64}, Float64}() 
    close::Matrix{Bool} = Matrix{Bool}(fill(false, (size(map, 1), size(map, 2)))) 

    dist::Matrix{Float64} = Matrix{Float64}(fill( -1,(size(map, 1), size(map, 2)))) 
    pred::Matrix{Tuple{Int64, Int64}} = Matrix{Tuple{Int64, Int64}}(undef, size(map, 1), size(map, 2))

    step::Int64 = 0
    found::Bool = false

    dist[src[1], src[2]] = 0  # distance from src to src is 0

    enqueue!(open, src, (w*dist[src[1], src[2]]) + ((1-w)*heuristic(src, target)))

    # -- AStar Algorithm --
    
    while !(found)
        step += 1

        # Choose the next cell to visit
        crt = dequeue!(open)    

        if crt != target 

            neighbor::Vector{Tuple{Int64,Int64}} = []

            # Neighbor coordinate
            north = (crt[1]-1, crt[2])
            east = (crt[1], crt[2]+1)
            south = (crt[1]+1, crt[2])
            west = (crt[1], crt[2]-1)
    
            # Calcul the cost of "traveling" from crt to each neighbor
            # if the neighbor is not accessible, do not add it to the list of neighbor

            for i in [north, east, south, west]
                if cost(map, i)[1]
                    push!(neighbor, i)
                end
            end
    
    
            #= for each accessible neighbor:
                evaluate the distance from the source
                add it to the priority queue with the heuristic value
                update the predecessor
            =#
            for i in neighbor

                new_dist::Int64 = dist[crt[1], crt[2]] + cost(map, i)[2]

                if dist[i[1], i[2]] > new_dist || !(close[i[1], i[2]])   

                    # if already visited before, delete from priority queue
                    if haskey(open, i) 
                        delete!(open, i)
                    end

                    dist[i[1], i[2]] = new_dist
                    pred[i[1], i[2]] = crt
                    enqueue!(open, i, (w*new_dist + (1-w)*heuristic(i, target)) )
                    close[i[1], i[2]] = true  
                end 
            end

            # if all the cells are visisited, stop the algorithm
            if isempty(open)
                println("Aucun chemin trouvé")
                found = true
            end
    
        else
            # We found the shortest path
            println("Chemin trouvé !")
            found = true
    
            while crt != src
                push!(path, crt)
                crt = pred[crt[1], crt[2]]
            end
            push!(path, src)
        end
    end
    
    println("Nombre d'étapes de recherche : ", step)
    println("Taille du chemin : ", dist[target[1], target[2] ])
    println("Nombre de cases du chemin : ", length(path))
    return (close, path)
end

function algoWAStar(file::String, src::Tuple{Int64, Int64}, target::Tuple{Int64, Int64}, w::Float64)
    map::Matrix{String} = read_map_file(string("map/",file))
    @time result = WAStar(map, src, target, w)
    show_map(map, result[1], result[2])
end
