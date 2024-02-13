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


function play_lights_out()
    rungame("src/GameSetup.jl")
end

end
