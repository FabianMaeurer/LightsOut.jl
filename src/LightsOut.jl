module LightsOut

using GameZero
using Oscar
using Colors

export play_lights_out

include("adjacency.jl")


function play_lights_out()
    rungame("src/GameSetup.jl")
end

end
