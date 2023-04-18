using Gtk, Graphics

function show_map(map::Matrix{String}, visited::Matrix{Bool}, path::Vector{Tuple{Int64, Int64}})

    maph = size(map,1)
    mapw = size(map,2)

    c = @GtkCanvas(512, 512)
    win = GtkWindow(c, "Map")

    #= 
    . - passable terrain
    G - passable terrain
    @ - out of bounds
    O - out of bounds
    T - trees (unpassable)
    S - swamp (passable from regular terrain)
    W - water (traversable, but not passable from terrain)
    =#

    @guarded draw(c) do widget

        color_value = Dict("W" => (0.,0.,1.), "T" => (0., 0.5, 0.), "G" => (0.95, 1., 0.85), "O" => (0.,0.,0.), "@" => (0.,0.,0.), "S" => (0.2, 0.6, 0.6), "." => (0.95, 1., 0.85))
        ctx = getgc(c) # graphic context
        h = height(c)
        w = width(c)

        
        for i in 1:maph
            for j in 1:mapw

                value = color_value[map[j,i]]
                r::Float64 = value[1]
                g::Float64 = value[2]
                b::Float64 = value[3]
                
                # draw map
                rectangle(ctx, (i-1)*w/mapw, (j-1)*h/maph, w/mapw, h/maph)
                if visited[j,i]
                    set_source_rgb(ctx, 0.2, 1, 0.2)
                else 
                    set_source_rgb(ctx, r, g, b)
                end
                fill(ctx)
            end
        end
        

        for i in path
            rectangle(ctx, (i[2]-1)*w/mapw, (i[1]-1)*h/maph, w/mapw, h/maph)
            set_source_rgb(ctx, 0.5, 0, 0)
            fill(ctx)
        end

    end

    show(c)
end
