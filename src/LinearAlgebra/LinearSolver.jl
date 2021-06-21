export LU , GMRES , BICGSTAB

abstract type AbstractLinearSolver end
abstract type DirectSolver <: AbstractLinearSolver end
abstract type IterativeSolver <: AbstractLinearSolver end

struct LU  <:DirectSolver end
struct GMRES  <: IterativeSolver end
struct BICGSTAB  <: IterativeSolver end


function linsolve(A::AbstractArray,b::AbstractVector,::LU)
A \ b
end

function linsolve(A::AbstractArray,b::AbstractVector,::GMRES)
    gmres(A,b,verbose = true)
end
   
function linsolve(A::AbstractArray,b::AbstractVector,::BICGSTAB)
    bicgstabl(A,b,verbose = true)
end
   