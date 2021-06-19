export using_direct_solver
export using_gmres
export using_bicgstabl

abstract type AbstractLinearSolver end
struct DirectSolver <: AbstractLinearSolver end
const using_direct_solver = DirectSolver()

struct GMRES <: AbstractLinearSolver end
const using_gmres = GMRES()

struct BICGSTAB <: AbstractLinearSolver end
const using_bicgstabl = BICGSTAB()


function linsolve(A::AbstractArray,b::AbstractVector,::DirectSolver)
 A \ b
end


function linsolve(A::AbstractArray,b::AbstractVector,::GMRES)
    gmres(A,b,verbose = true)
end
   
function linsolve(A::AbstractArray,b::AbstractVector,::BICGSTAB)
    bicgstabl(A,b,verbose = true)
end
   