using Photon
using Documenter

DocMeta.setdocmeta!(Photon, :DocTestSetup, :(using Photon); recursive=true)

makedocs(;
    modules=[Photon],
    authors="Mohamed Kamal AbdElrahman",
    repo="https://github.com/MKAbdElrahman/Photon.jl/blob/{commit}{path}#{line}",
    sitename="Photon.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MKAbdElrahman.github.io/Photon.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;devbranch = "main",
    repo="github.com/MKAbdElrahman/Photon.jl",
)
