module Photon

using LinearAlgebra: getproperty
using Base: Symbol
using  LinearAlgebra
using  SparseArrays
#using  Arpack 
using  Gnuplot


include("types.jl")
include("Grid.jl")
include("utils.jl")
include("Simulation.jl")
include("Devices/Device.jl")
include("TFSF.jl")
include("PML.jl")
include("Sources/Source.jl")
include("Sources/PlaneWave.jl")

include("BC.jl")
include("∂.jl")

#include("Devices/devices_2D.jl")
#include("ModeSolver/scaler_mode_solver.jl")
#include("sim_objects.jl")
include("Plot.jl")

end # module
