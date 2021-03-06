module IntegratedOptics


using  LinearAlgebra
using  SparseArrays

include("types.jl")
include("Interface/Simulation.jl")
include("LinearAlgebra/LinearAlgebra.jl")
include("Solvers/FDFD/FDFDSolver.jl")
include("Solvers/ModeSolver/FullVectorialModeSolver.jl")
include("Optimization/Optimization.jl")
include("Plots/Plots.jl")

end # module
