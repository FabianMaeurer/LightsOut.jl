# LightsOut.jl

A light demo package to showcase the combinatorial game "Lights Out" on an n-by-n played on simple manifolds like the torus, kleinian bottle or the projective plane.

We want to play the classic game [Lights Out](https://en.wikipedia.org/wiki/Lights_Out_(game)) on different kinds of manifolds and solve the game in those cases. The main feature of this package is a graphical interface to play the game on such surfaces.

## Usage

Install the package like this: 

```julia
julia> import Pkg
julia> Pkg.add(url = "https://github.com/FabianMaeurer/LightsOut.jl")
```

To play the game do the following

```julia 
play_lights_out()
```

