push!(LOAD_PATH,"../src/")
using IntegratedOptics
using Documenter

DocMeta.setdocmeta!(Photon, :DocTestSetup, :(using IntegratedOptics); recursive=true)

makedocs(;
    modules=[Photon],
    authors="Mohamed Kamal AbdElrahman",
    repo="https://github.com/MKAbdElrahman/IntegratedOptics.jl/blob/{commit}{path}#{line}",
    sitename="Photon.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MKAbdElrahman.github.io/IntegratedOptics.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;devbranch = "main",
    repo="github.com/MKAbdElrahman/IntegratedOptics.jl",
)
