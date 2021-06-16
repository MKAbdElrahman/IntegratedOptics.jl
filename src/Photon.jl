module Photon

using LinearAlgebra: getproperty
using Base: Symbol
using  LinearAlgebra
using  SparseArrays
#using  Arpack 
using  Gnuplot


include("types.jl")
include("Interface/Simulation.jl")
include("Solvers/FDFD/FDFDSolver.jl")
#include("Devices/devices_2D.jl")
#include("ModeSolver/scaler_mode_solver.jl")
#include("sim_objects.jl")
include("Graphics/Plot.jl")

end # module
