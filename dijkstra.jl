using DataStructures

include("read_map_file.jl")
include("show_map.jl")


#= 
    Return the cost value of a cell which contains :
    a boolean, true if the cell is accessible, false otherwise
    an integer, cost of "traveling"
=#
function cost(map::Matrix{String}, cell::Tuple{Int64, Int64})

    # is out of bounds ?
    if cell[1] > size(map, 1) || cell[2] > size(map, 2) || cell[1] < 1 || cell[2] < 1
        return (false, 0) 
    end

     # type of the cell ( a character )
    c = map[cell[1], cell[2]]
    
    # evaluation 
    if c == "@" || c == "T" || c == "O"
        return (false, 0)
    end 

    if c == "." || c == "G"
        return (true,1)
    elseif c == "S"
        return (true,5)
    else c == "W"
        return (true,8)
    end
end


#= 
    Dijkstra Algorithm
    From a map, a starting point and a ending point, return the shortest path
=#
function dijkstra(map::Matrix{String}, src::Tuple{Int64, Int64}, target::Tuple{Int64, Int64})

    # Initialize 

    path::Vector{Tuple{Int64, Int64}} = []
    visited::Vector{Tuple{Int64, Int64}} = []
    
    open = PriorityQueue{Tuple{Int64,Int64}, Int64}() 
    close::Matrix{Bool} = Matrix{Bool}(fill(false, (size(map, 1), size(map, 2))))
    
    dist::Matrix{Int64} = Matrix{Int64}(fill( -1,(size(map, 1), size(map, 2)) ))   # Matrix of distance from the source
    pred::Matrix{Tuple{Int64, Int64}} = Matrix{Tuple{Int64, Int64}}(undef, size(map, 1), size(map, 2))  # Matrix of predecessors
    
    step::Int64 = 0
    found::Bool = false

    dist[src[1], src[2]] = 0  # distance of the source is 0
    enqueue!(open, src, dist[src[1], src[2]])

    # -- Dijkstra Algorithm --
    
    
    while !(found)
        step +=1

        # Choose the next cell to visit
        crt = dequeue!(open)
        push!(visited, crt)
    
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
                add it to the priority queue with the distance value
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
                    enqueue!(open, i, new_dist)
                    close[i[1], i[2]] = true  
                end 
            end
            
            # if all the cells are visisited, stop the algorithm
            if isempty(open)
                println("Aucun chemin trouvé")
                found = true
            end
    
        else
            println("Chemin trouvé !")
            found = true
    
            push!(visited, crt)
    
            while crt != src
                push!(path, crt)
                crt = pred[crt[1], crt[2]]
            end
            push!(path, src)
        end
    end
    
    # calcul du plus cours chemin
    println("Nombre d'étapes de recherche : ", step)
    println("Taille du chemin : ", dist[target[1], target[2] ])
    println("Nombre de cases du chemin : ", length(path))
    return (visited, path)
end
    
function algoDijkstra(file::String, src::Tuple{Int64, Int64}, target::Tuple{Int64, Int64})
    map::Matrix{String} = read_map_file(string("map/",file))
    @time result = dijkstra(map, src, target)
    show_map(map, result[1], result[2])
end