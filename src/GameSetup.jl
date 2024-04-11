using LightsOut.Math, LightsOut.GameZero

@show pwd()

BACKGROUND = "torus_background.jpg"
#BACKGROUND = colorant"black"
HEIGHT = 800
WIDTH = 1200

title_actor = TextActor("Lights Out - Manifold Edition", "moonhouse", center = (1200,100), font_size = 96)
#title_actor.scale = [3,3]

global SETTINGS = Dict(:surface => :square, 
                        :surface_index => 1, 
                        :n => 5,
                        :solution => nothing,
                        :show_solution => false,
                        :solved => false,
                        :edit => false)

global TEMP_SETTINGS = SETTINGS


function build_blocks()
    global n = SETTINGS[:n]
    global block_width = Int(floor((1200 - (n+1)*10)/n)) 
    global off_set = 1200 - n*block_width - (n+1)*10 
    global game_grid = Rect(WIDTH + 300 - 600, HEIGHT - 500,1200 - off_set,1200 - off_set)
    global game_border = Rect(WIDTH + 300 - 620, HEIGHT - 520,1240 - off_set, 1240 - off_set)

    block_coordinates = [(x,y) for x ∈ WIDTH + 300 - 590:block_width + 10:WIDTH + 900 - off_set - block_width, y ∈ HEIGHT - 490:block_width + 10:HEIGHT + 700 - off_set - block_width]

    global blocks = [Rect(x,y,block_width, block_width) for (x,y) ∈ block_coordinates]

    # Solution indicators
    global sol_indecs = [Circle(Int.(floor.(B.center))..., Int(floor(0.35*block_width))) for B ∈ blocks]
end

build_blocks()

function make_solvable()
    global solvable = false
    while !solvable 
        global config = rand(Bool, n,n)
        global solvable, solution = is_solvable(config, SETTINGS[:surface])
        solvable
    end

    SETTINGS[:solution] = vector_to_grid(solution, n)
end

make_solvable()
#=----------------------------------------------------------
    Menu    
----------------------------------------------------------=#



menu_grid = Rect(100, HEIGHT - 500, 500, 1200 - off_set)
menu_border = Rect(90, HEIGHT - 510, 520, 1220 - off_set)
menu_title = TextActor("Settings", "moonhouse", font_size = 60, center = (350, HEIGHT - 450))
#menu_title.scale = [2,2]

# Choose Grid Size
n_buttons_coordinates = [(x,y) for x ∈ 120:98:540, y ∈ [HEIGHT - 350, HEIGHT - 252, HEIGHT - 154]][:]
n_buttons = [Rect(x,y,68,68) for (x,y) ∈ n_buttons_coordinates][:]
n_buttons_border = [Rect(x-10,y-10,88,88) for (x,y) ∈ n_buttons_coordinates][:]
n_buttons_numbers = [TextActor("$n", "moonhouse", font_size = 48, center = B.center) for (n,B) ∈ zip(3:18, n_buttons)][:]

#choose Game-mode 
surfaces = ["Square", "Cylinder", "Moebius Strip", "Torus", "Kleinian Bottle", "Projective Plane"]
surface_symbols = [:square, :cylinder, :moebius_strip, :torus, :kleinian_bottle, :projective_plane]

surface_buttons_coordinates = [(120,y) for y ∈ HEIGHT-20:98:HEIGHT + 500]
surface_buttons = [Rect(x,y,460, 68) for (x,y) ∈ surface_buttons_coordinates]
surface_buttons_border = [Rect(x-10,y-10,480,88) for (x,y) ∈ surface_buttons_coordinates]
surface_names = [TextActor(name, "moonhouse", font_size = 48, center = B.center) for (name,B) ∈ zip(surfaces, surface_buttons)]

#play button
play_button = Rect(120, HEIGHT + 500 - off_set + 88, 460, 68)
play_text = TextActor("Play", "moonhouse", center = play_button.center, font_size = 48)
play_button_border = Rect(110, HEIGHT + 500 - off_set + 78, 480, 88)

# help button
help_button = Rect(game_grid.right + 60, game_grid.top, 200, 200)
help_button_border = Rect(help_button.left - 10, help_button.top - 10, 220, 220)
help_button_text = TextActor("?", "moonhouse", font_size = 90, center = help_button.center)

edit_button = Rect(game_grid.right + 60, game_grid.top + 220, 200, 200)
edit_button_border = Rect(edit_button.left - 10, edit_button.top - 10, 220, 220)
edit_button_text = TextActor("Edit", "moonhouse", font_size = 60, center = edit_button.center)

#Victory TextActor
victory_text = TextActor("Victory!", "moonhouse", font_size = 250, center = game_grid.center)

# Not solveable text
not_solveable_text = TextActor("No Solution", "moonhouse", font_size = 180, center = game_grid.center)

function draw()
    draw(title_actor)
    draw(game_border, colorant"orangered4", fill = true)
    draw(game_grid, colorant"grey", fill = true)

    draw(menu_border, colorant"orangered4", fill = true)
    draw(menu_grid, colorant"darkslategray", fill = true)
    draw(menu_title)

    # Draw Lights
    for (B,l) ∈ zip(blocks, config)
        draw(B, l ? colorant"beige" : colorant"grey18", fill = true)
    end

    # Draw solution indicators
    if SETTINGS[:show_solution]
        if SETTINGS[:solution] === nothing
            draw(not_solveable_text)
        else
            for (ind,s) ∈ pairs(sol_indecs)
                if SETTINGS[:solution][Tuple(ind)...]
                    draw(s, colorant"lightsalmon", fill = true)
                end
            end
        end
    end


    #draw Buttons for grid size
    for (B,b,n) ∈ zip(n_buttons, n_buttons_border, n_buttons_numbers)
        draw(b, colorant"gray12", fill = true)
        draw(B, colorant"slategrey", fill = true)
        draw(n)
    end

    n_set_border = n_buttons_border[SETTINGS[:n] - 2]
    n_set_button = n_buttons[SETTINGS[:n] - 2]
    n_set_number = n_buttons_numbers[SETTINGS[:n] - 2]
    
    draw(n_set_border, colorant"red", fill = true)
    draw(n_set_button, colorant"slategrey", fill = true)
    draw(n_set_number)

    #draw buttons for surface
    for (B,b,n) ∈ zip(surface_buttons, surface_buttons_border, surface_names)
        draw(b, colorant"gray12", fill = true)
        draw(B, colorant"slategrey", fill = true)
        draw(n)
    end

    surf_set_border = surface_buttons_border[SETTINGS[:surface_index]...]
    surf_set_button = surface_buttons[SETTINGS[:surface_index]...]
    surf_set_number = surface_names[SETTINGS[:surface_index]...]

    draw(surf_set_border, colorant"red", fill = true)
    draw(surf_set_button, colorant"slategrey", fill = true)
    draw(surf_set_number)

    draw(play_button_border, colorant"gray12", fill = true)
    draw(play_button, colorant"slategrey", fill = true)
    draw(play_text)

    # help button
    draw(help_button_border, SETTINGS[:show_solution] ? colorant"red" : colorant"gray12", fill = true)
    draw(help_button, colorant"slategrey", fill = true)
    draw(help_button_text)

    # Edit button
    draw(edit_button_border, SETTINGS[:edit] ? colorant"red" : colorant"gray12", fill = true)
    draw(edit_button, colorant"slategrey", fill = true)
    draw(edit_button_text)

    # Draw victory
    if sum(config) == 0
        draw(victory_text)
    end
end

function update()

end

function on_mouse_down(g::Game, pos, button)
    x,y = 2 .* pos

    # Check region
    if collide(menu_grid, (x,y))
        on_mouse_down_menu(pos)
        return
    end

    if collide(help_button, (x,y))
        SETTINGS[:show_solution] ⊻= true
        if SETTINGS[:show_solution] && SETTINGS[:edit] 
            SETTINGS[:edit] = false
            solveable, solution = is_solvable(config, SETTINGS[:surface])
            
            SETTINGS[:solution] = solveable ? vector_to_grid(solution,SETTINGS[:n]) : nothing
        end
        return 
    end

    if collide(edit_button, (x,y))
        if SETTINGS[:edit]
            solveable, solution = is_solvable(config, SETTINGS[:surface])
            
            SETTINGS[:solution] = solveable ? vector_to_grid(solution,SETTINGS[:n]) : nothing
        end
        SETTINGS[:show_solution] = false
        SETTINGS[:edit] ⊻= true
    end

    if SETTINGS[:edit]
        on_mouse_down_edit(pos)
    else
        on_mouse_down_grid(pos)
    end

end

function on_mouse_down_grid(pos)
    x,y = 2 .* pos

    ind = findfirst(a -> collide(a, (x,y)), blocks)

    ind === nothing && return 
    
    i,j = Tuple(ind)
    config[i,j] ⊻= true
    SETTINGS[:solution][i,j] ⊻= true

    for (k,l) ∈ adjacent_squares(i,j,n, SETTINGS[:surface])
        config[k,l] ⊻= true
    end
    if sum(config) == 0
        SETTINGS[:solved] = true
    end
end

function on_mouse_down_edit(pos)
    x,y = 2 .* pos

    ind = findfirst(a -> collide(a, (x,y)), blocks)

    ind === nothing && return 

    i,j = Tuple(ind)

    config[i,j] ⊻= true
end


function on_mouse_down_menu(pos)
    x,y = 2 .* pos

    ind = findfirst(B -> collide(B, (x,y)), n_buttons)

    if ind !== nothing
        TEMP_SETTINGS[:n] = ind + 2
        return 
    end

    ind = findfirst(B -> collide(B, (x,y)), surface_buttons)

    if ind !== nothing 
        TEMP_SETTINGS[:surface] = surface_symbols[ind]
        TEMP_SETTINGS[:surface_index] = ind
        return
    end

    if collide(play_button, (x,y))
        SETTINGS = TEMP_SETTINGS
        SETTINGS[:show_solution] = false
        SETTINGS[:solved] = false
        n = SETTINGS[:n]
        #global config = rand(Bool, n,n)
        build_blocks()
        make_solvable()
    end

end


# #=----------------------------------------------------------
#     adjacency 
# ----------------------------------------------------------=#

# function adjacent_squares(i::Int, j::Int, n::Int, surface)
#     surface == :square && return plain_adjacent_squares(i,j,n)
#     surface == :cylinder && return cylinder_adjacent_squares(i,j,n)
#     surface == :torus && return torus_adjacent_squares(i,j,n)
#     surface == :moebius_strip && return moebius_adjacent_squares(i,j,n)
#     surface == :kleinian_bottle && return kleinian_bottle_adjacent_squares(i,j,n)
#     surface == :projective_plane && return projective_plane_adjacent_squares(i,j,n)
# end

# function torus_adjacent_squares(i::Int, j::Int, n::Int)
#     [(i,mod(j,n)+1),
#      (i,mod(j-2,n)+1),
#      (mod(i,n)+1, j),
#      (mod(i-2,n)+1, j)]
# end

# function plain_adjacent_squares(i::Int, j::Int, n::Int)
#     # Edge cases
#     i ∈ [1,n] && j ∈ [1,n] && return [(i,j == 1 ? 2 : n-1), (i == 1 ? 2 : n-1, j)]
#     i ∈ [1,n] && return [(i,j-1), (i,j+1), (i == 1 ? 2 : n-1, j)]
#     j ∈ [1,n] && return [(i, j == 1 ? 2 : n-1), (i+1,j), (i-1, j)]

#     [(i,j+1),
#      (i,j-1),
#      (i+1,j),
#      (i-1,j)]
# end

# function cylinder_adjacent_squares(i::Int, j::Int, n::Int)
#     if j == 1
#         return [(mod(i,n)+1,j), (mod(j-2,n)+1,i), (i, 2)]
#     elseif j == n
#         return [(mod(i,n)+1,j), (mod(i-2,n)+1,j), (i, n-1)]
#     else
#         return [(mod(i,n)+1,j),
#         (mod(i-2,n)+1,j),
#         (i, j+1),
#         (i, j-1)]
#     end
# end

# function moebius_adjacent_squares(i::Int, j::Int, n::Int)
#     if j == 1
#         if i == 1
#             return [(n,n), (1,2), (2,1)]
#         elseif i == n
#             return [(1,n), (n-1,1), (n,2)]
#         else
#             return [(i-1,1), (i+1,1), (i,2)]
#         end
#     elseif j == n
#         if i == 1
#             return [(n,1), (2,n), (1,n-1)]
#         elseif i == n
#             return [(1,1), (n-1,n), (n,n-1)]
#         else
#             return [(i-1,n), (i+1,n), (i,n-1)]
#         end
#     end

#     if i == 1 
#         return [(1,j+1), (1,j-1), (2,j), (n,n-j+1)]
#     elseif i == n
#         return [(n,j+1), (n,j-1), (n-1,j), (1,n-j+1)]
#     end

#     [(i,j+1),
#     (i,j-1),
#     (i+1,j),
#     (i-1,j)]
# end

# function projective_plane_adjacent_squares(i::Int, j::Int, n::Int)
#     # Edge cases
#     if i == 1
#         if j == 1
#             return [(n,n), (1,2), (2,1)]
#         elseif j == n
#             return [(n,1), (1,n-1), (2,n)]
#         else
#             return [(1,j-1), (1,j+1), (2,j), (n, n-j+1)]
#         end
#     elseif i == n
#         if j == n 
#             return [(1,1), (n-1,n), (n,n-1)]
#         elseif j == 1
#             return [(1,n), (n-1,1), (n,2)]
#         else
#             return [(n,j-1), (n,j+1), (1, n-j+1), (n-1, j)]
#         end
#     end

#     if j == 1
#         return [(i+1,1), (i-1,1), (n-i+1,n), (i,2)]
#     elseif j == n
#         return [(i+1,n), (i-1,n), (i,n-1), (n-i+1,1)]
#     end

#     [(i,j+1),
#     (i,j-1),
#     (i+1,j),
#     (i-1,j)]
# end

# function kleinian_bottle_adjacent_squares(i::Int, j::Int, n::Int)
#     if i == 1
#         [(i,mod(j,n)+1),
#         (i,mod(j-2,n)+1),
#         (i+1,j),
#         (n, n - j + 1)]
#     elseif i == n
#         [(i,mod(j,n)+1),
#         (i,mod(j-2,n)+1),
#         (1, n - j + 1),
#         (n-1, j)]
#     else
#         [(i,mod(j,n)+1),
#         (i,mod(j-2,n)+1),
#         (mod(i,n)+1, j),
#         (mod(i-2,n)+1, j)]
#     end
# end