using LightsOut, Documenter

makedocs(
    sitename = "LightsOut.jl",
    modules = [LightsOut],
    warnonly = true,
    format = Documenter.HTML(
        canonical = "https://juliadocs.github.io/Documenter.jl/stable/",
        prettyurls = !("local" in ARGS)
    ),
    pages = [
        "Home" => "index.md"
    ],
)


deploydocs(
    repo   = "github.com/FabianMaeurer/LightsOut.jl.git",
)