module LightsOut

using GameZero
using Oscar
using Colors

import Oscar: is_solvable

export play_lights_out
export lights_out_matrix
export is_solvable
export uniquely_solvable_up_to


include("adjacency.jl")
include("Solving.jl")
include("Math.jl")

@show pwd()

function play_lights_out()
    rungame(joinpath(@__DIR__, "GameSetup.jl"))
end

end
