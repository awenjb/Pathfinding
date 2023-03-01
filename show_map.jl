using Gtk, Graphics

function show_map(map::Matrix{String})

    maph = size(map,1)
    mapw = size(map,2)

    c = @GtkCanvas(512, 512)
    win = GtkWindow(c, "Map")


    @guarded draw(c) do widget
        ctx = getgc(c) # graphic context
        h = height(c)
        w = width(c)

        for i in 1:maph
            for j in 1:mapw
                
                # select color
                if map[j,i] == "T" 
                    r = 0
                    g = 0.5
                    b = 0
                elseif map[j,i]  == "G" || map[j,i] == "O"
                    r = 0
                    g = 0
                    b = 0
                elseif map[j,i] == "W"
                    r = 0
                    g = 0
                    b = 1
                elseif map[j,i] == "S"
                    r = 0.2
                    g = 0.6
                    b = 0.6
                else
                    r = 0.95
                    g = 1
                    b = 0.85
                end

                # draw map
                rectangle(ctx, (i-1)*w/mapw, (j-1)*h/maph, w/mapw, h/maph)
                set_source_rgb(ctx, r, g, b)
                fill(ctx)
            end
        end

        # detect a click on the canva
        c.mouse.button1press = @guarded (widget, event) -> begin
        println("x : ", event.x , " y : ", event.y)
        
        end 

    end

    show(c)
end
