module Photon


using  LinearAlgebra: getproperty
using  Base: Symbol, Float64
using  LinearAlgebra
using  SparseArrays
using  Arpack 
using  IterativeSolvers
using  Gnuplot


include("types.jl")
include("Interface/Simulation.jl")
include("LinearAlgebra/LinearSolver.jl")
include("Solvers/FDFD/FDFDSolver.jl")
include("Solvers/ModeSolver/FullVectorialModeSolver.jl")
include("PostProcess/PostProcess.jl")
include("Graphics/Plot.jl")

end # module
