
BACKGROUND = "torus_background.jpg"
#BACKGROUND = colorant"black"
HEIGHT = 800
WIDTH = 1200

title_actor = TextActor("Lights Out - Torus Edition", "moonhouse", center = (600,100))
title_actor.scale = [3,3]

n = 5

block_width = Int(floor((1200 - (n+1)*10)/n)) 
off_set = 1200 - n*block_width - (n+1)*10 
game_grid = Rect(WIDTH + 300 - 600, HEIGHT - 500,1200 - off_set,1200 - off_set)
game_border = Rect(WIDTH + 300 - 620, HEIGHT - 520,1240 - off_set, 1240 - off_set)


block_coordinates = [(x,y) for x ∈ WIDTH + 300 - 590:block_width + 10:WIDTH + 300 + 570, y ∈ HEIGHT - 490:block_width + 10:HEIGHT + 570]

blocks = [Rect(x,y,block_width, block_width) for (x,y) ∈ block_coordinates]

config = rand(Bool, n,n)

#=----------------------------------------------------------
    Menu    
----------------------------------------------------------=#

menu_grid = Rect(100, HEIGHT - 500, 500, 1200 - off_set)
menu_border = Rect(90, HEIGHT - 510, 520, 1220 - off_set)
menu_title = TextActor("Settings", "moonhouse", center = (250, HEIGHT - 450))
menu_title.scale = [2,2]

function draw()
    draw(title_actor)
    draw(game_border, colorant"orangered4", fill = true)
    draw(game_grid, colorant"grey", fill = true)

    draw(menu_border, colorant"orangered4", fill = true)
    draw(menu_grid, colorant"darkslategray", fill = true)
    draw(menu_title)

    for (B,l) ∈ zip(blocks, config)
        draw(B, l ? colorant"beige" : colorant"grey18", fill = true)
    end
end

function update()

end

function on_mouse_down(g::Game, pos, button)
    x,y = 2 .* pos
    ind = findfirst(a -> x ∈ a[1]:a[1]+block_width && y ∈ a[2]:a[2]+block_width, block_coordinates)

    ind == nothing && return 
    
    i,j = Tuple(ind)
    config[i,j] ⊻= true
    for (k,l) ∈ torus_adjacent_squares(i,j,n)
        config[k,l] ⊻= true
    end
end

function torus_adjacent_squares(i::Int, j::Int, n::Int)
    [(i,mod(j,n)+1),
     (i,mod(j-2,n)+1),
     (mod(i,n)+1, j),
     (mod(i-2,n)+1, j)]
end

    