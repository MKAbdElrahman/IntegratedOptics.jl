export LU , GMRES , BICGSTAB

abstract type AbstractLinearSolver end
abstract type DirectSolver <: AbstractLinearSolver end
abstract type IterativeSolver <: AbstractLinearSolver end

struct LU  <:DirectSolver end
struct GMRES  <: IterativeSolver end
struct BICGSTAB  <: IterativeSolver end


function linsolve!(x::AbstractVector,A::AbstractArray,b::AbstractVector, ::LU)
ldiv!(x, lu(A), b);
end

function linsolve!(x::AbstractVector,A::AbstractArray,b::AbstractVector,::GMRES)
gmres!(x,A,b,verbose = true)
end
   
function linsolve!(x::AbstractVector,A::AbstractArray,b::AbstractVector,::BICGSTAB)
bicgstabl!(x,A,b,verbose = true)
end
   