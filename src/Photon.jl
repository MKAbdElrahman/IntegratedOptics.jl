module Photon

using  LinearAlgebra
using  SparseArrays
using  Arpack 
using  Gnuplot



include("types.jl")
include("Grid.jl")
include("PML.jl")
include("BC.jl")
include("∂.jl")
include("Devices/Device.jl")
include("Devices/devices_2D.jl")
include("sim_objects.jl")
include("plot.jl")

end # module
