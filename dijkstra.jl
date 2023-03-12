using DataStructures

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

function dijkstra(map::Matrix{String}, src::Tuple{Int64, Int64}, target::Tuple{Int64, Int64})

    path::Vector{Tuple{Int64, Int64}} = []  # shortest path
    
    open = PriorityQueue{Tuple{Int64,Int64}, Int64}() 
    close::Matrix{Bool} = Matrix{Bool}(fill(false, (size(map, 1), size(map, 2))))
    
    dist::Matrix{Int64} = Matrix{Int64}(fill( -1,(size(map, 1), size(map, 2)) ))   # Matrix of distance from the source
    
    pred::Matrix{Tuple{Int64, Int64}} = Matrix{Tuple{Int64, Int64}}(undef, size(map, 1), size(map, 2))  # Matrix of predecessors
    
    visited::Vector{Tuple{Int64, Int64}} = []
    
    
    # Initialize 
    
    step::Int64 = 0

    dist[src[1], src[2]] = 0  # distance to source is 0

    enqueue!(open, src, dist[src[1], src[2]])

    
    # -- Dijkstra --
    
    found::Bool = false
    while !(found)

        # Choisir premier sommet S dans next_cells de plus petite distance

        crt = dequeue!(open)
    
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
    
                    # ajout du voisin dans la liste des cellules proches s'il n'a pas déjà été visité
                    if !(close[i[1], i[2]])
                        enqueue!(open, i, dist[i[1], i[2]])
                        close[i[1], i[2]] = true
                    end
                    
                end 
            end

            # ajouter S dans la liste des visités
            push!(visited, crt)
    
    
            if isempty(open)
                println("no path found")
                found = true
            end
    
        else
            println("trouvé !")
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
    println("nb d'étapes : ", step)
    println("taille du chemin : ", length(path))
    return (visited, path)
end
    
