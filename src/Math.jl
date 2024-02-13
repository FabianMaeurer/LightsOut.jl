module Math

using Oscar

export adjacent_squares, lights_out_matrix, is_solvable, vector_to_grid

include("adjacency.jl")
include("Solving.jl")

end