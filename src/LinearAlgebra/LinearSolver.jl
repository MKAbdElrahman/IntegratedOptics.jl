export using_direct_solver


abstract type AbstractLinearSolver end
struct DirectSolver <: AbstractLinearSolver end

const using_direct_solver = DirectSolver()

function linsolve(A::AbstractArray,b::AbstractVector,::DirectSolver)
 A \ b
end


