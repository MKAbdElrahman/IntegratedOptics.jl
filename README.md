# Photon


<!-- [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://MKAbdElrahman.github.io/Photon.jl/stable) -->
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://MKAbdElrahman.github.io/Photon.jl/dev)
[![Build Status](https://github.com/MKAbdElrahman/Photon.jl/workflows/CI/badge.svg)](https://github.com/MKAbdElrahman/Photon.jl/actions)
[![Coverage](https://codecov.io/gh/MKAbdElrahman/Photon.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/MKAbdElrahman/Photon.jl)

## Getting Started: Installation 
To install the package, use the following command inside the Julia REPL:
```julia
using Pkg
Pkg.add("https://github.com/MKAbdElrahman/Photon.jl")
```

To load the package, use the command:

```julia
using Photon
```
## Quick Overview
```julia
using Photon

λ = 1.55;

Lx = 6 * λ; 
Ly = 6 * λ;

sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (λ/40,λ/40) ))

sim(setpml!,λ)
sim(setsrc!, PlaneWave(k̂ = (0,2pi/λ), ê = (0,0,1)))
sim(setTFSF! ,1.5λ)

Si = Material(ϵᵣ = 13.491 + 0.036730im )
inDisk(x) = sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2)  <=  1.2 
sim(setmaterial!,Si,inDisk)

sim(solve!)

```
## Features List
### Spaces
* 1D, 2D, 3D
### Materials
* lossy and lossless isotropic and anistropic materials
### Sources
* planewave source
* eigenmode source
* custom source
### TFSF
- Ability to seperate total fields from scattered fields at any user defined regions
### Perfect Macthed Layer (PML)
* complex stretched PML
### Solvers
- direct solvers 
- iterative solvers (GMRES and BICGSTABl)
### Plots
- line plots
- contour plots
