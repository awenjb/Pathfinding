using OrderedCollections

# heuristique : Distance de Manhattan

function h(A::Tuple{Int64,Int64}, B::Tuple{Int64,Int64})
    return abs(B[1]-A[1]) + abs(B[2]-A[2])
end


# function returning the minimum value of an ordered set of cells
function minDistance(M::Matrix{Int64}, cells::OrderedSet{Tuple{Int64,Int64}}, goal::Tuple{Int64,Int64} )

    min::Int64 = M[cells[1][1], cells[1][2]] + h((cells[1][1], cells[1][2]), goal)
    min_index::Tuple{Int64,Int64} = (cells[1][1], cells[1][2])

    # from the set non visited and accessible cells, find the the cell with the shortest path value from the start
    for i in eachindex(cells)
        f::Int64 = M[cells[i][1], cells[i][2]] + h((cells[i][1], cells[i][2]), goal)
        if ( f < min )
            min = f
            min_index = cells[i]
        end
    end 
    return min_index
end



# Function returning a Tuple (Bool, int) which represent if the cell is accessible and it costs
# costs :
# any -> water : 8
# any -> swamp : 5
# any -> normal: 1
function cost(map::Matrix{String}, cell::Tuple{Int64, Int64})

    # is out of bounds ?
    if cell[1] > size(map, 1) || cell[2] > size(map, 2) || cell[1] < 1 || cell[2] < 1
        return (false, 0) 
    end

    # character of the cell
    c = map[cell[1], cell[2]]
    
    # is passable ?
    if c == "@" || c == "T" || c == "O"
        return (false, 0)
    end 

    # if passable what cost ?
    if c == "." || c == "G"
        return (true,1)
    elseif c == "S"
        return (true,5)
    else c == "W"
        return (true,8)
    end
end

function AStar(map::Matrix{String}, src::Tuple{Int64, Int64}, target::Tuple{Int64, Int64})

    path::Vector{Tuple{Int64, Int64}} = []  # shortest path
    
    near::OrderedSet{Tuple{Int64,Int64}} = OrderedSet{Tuple{Int64,Int64}}() # contains next to visit cells
    
    dist::Matrix{Int64} = Matrix{Int64}(fill( -1,(size(map, 1), size(map, 2)) ))   # Matrix of distance from the source
    
    pred::Matrix{Tuple{Int64, Int64}} = Matrix{Tuple{Int64, Int64}}(undef, size(map, 1), size(map, 2))  # Matrix of predecessors
    
    visited::Vector{Tuple{Int64, Int64}} = []
    
    
    # Initialize 
    
    step::Int64 = 0
    dist[src[1], src[2]] = 0  # distance to source is 0
    
    empty!(near)
    push!(near, src)
    
    # -- Dijkstra --
    
    found::Bool = false
    while !(found)
        step += 1
        # Choisir premier sommet S dans next_cells de plus petite distance
        crt = minDistance(dist, near, target)
    
        if isempty(near)
            println("no path found")
            found = true
        end
    
        if crt != target 
    
            # Coordonnée voisins
            north = (crt[1]-1, crt[2])
            east = (crt[1], crt[2]+1)
            south = (crt[1]+1, crt[2])
            west = (crt[1], crt[2]-1)
    
            # Cout de trajet des voisins 
    
            neighbor::Vector{Tuple{Int64,Int64}} = []
    
            for i in [north, east, south, west]
                if cost(map, i)[1]
                    push!(neighbor, i)
                end
            end
    
    
            # Pour chaque voisin de S faire :
            for i in neighbor
                # Si dist voisin > S + poids s -> Voisin
                if dist[i[1], i[2]] > dist[crt[1], crt[2]] || dist[i[1], i[2]] == -1
                    # dist de voisin devient S + poids s -> Voisin 
                    dist[i[1], i[2]] = dist[crt[1], crt[2]] + cost(map, i)[2]
                    # pred de voisin devient S
                    pred[i[1], i[2]] = crt
    
                    # ajout du voisin dans la liste des cellules proches
                    push!(near, i)
                    
                end 
            end
    
            # retire S de la liste des visitables
            delete!(near, crt)
            # ajouter S dans la liste des visiter
            push!(visited, crt)
    
    
            if isempty(near)
                println("no path found")
                found = true
            end
    
        else
            println("trouvé !")
            found = true
    
            delete!(near, crt)
            push!(visited, crt)
    
            while crt != src
                push!(path, crt)
                crt = pred[crt[1], crt[2]]
            end
            push!(path, src)
        end
    end
    
    # calcul du plus cours chemin
    println("nb d'étapes : ", step)
    println("taille du chemin : ", length(path))
    return (visited, path)
end
    

