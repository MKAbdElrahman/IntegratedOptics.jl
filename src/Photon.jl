module Photon

using Zygote: sensitivity
using LinearAlgebra: getproperty
using Base: Symbol, Float64
using  LinearAlgebra
using  SparseArrays
using  Arpack 
using IterativeSolvers
using  Zygote
using  Gnuplot


include("types.jl")
include("Interface/Simulation.jl")
include("LinearAlgebra/LinearSolver.jl")
include("Solvers/FDFD/FDFDSolver.jl")
include("Solvers/ModeSolver/FullVectorialModeSolver.jl")
include("PostProcessing/PostProcess.jl")
#include("Devices/devices_2D.jl")
#include("ModeSolver/scaler_mode_solver.jl")
#include("sim_objects.jl")
include("Optimization/AdjointMethod/Sensitivty.jl")
include("Graphics/Plot.jl")

end # module
