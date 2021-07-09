
import IterativeSolvers: gmres!, bicgstabl!
import LinearAlgebra: ldiv!

abstract type AbstractLinearSolver end
abstract type DirectSolver <: AbstractLinearSolver end
abstract type IterativeSolver <: AbstractLinearSolver end

struct LU  <:DirectSolver end
struct GMRES  <: IterativeSolver end
struct BICGSTAB  <: IterativeSolver end

linsolve(A,b ; args...) = linsolve(A,b,LU() ; args...)


function linsolve(A,b,solver::AbstractLinearSolver ; args...)
    x = similar(b)
    linsolve!(x,A,b,solver; args...)
    return x
end

linsolve!(x,A,b ; args...) = linsolve!(x,A,b,LU() ; args...)

function linsolve!(x,A,b , ::LU ; args...)
  ldiv!(x, lu(A), b; args...)
end
     

function linsolve!(x,A,b,::GMRES ; args...)
    gmres!(x,A,b; args...)
end
   
function linsolve!(x,A,b,::BICGSTAB ; args...)
    bicgstabl!(x,A,b; args...)
end




# methods for sensitivty analysis
function linsolve!(x,x_adj,A,b,b_adj,::LU ; args...)
    F = lu(A)
    ldiv!(x, F, b; args...)
    ldiv!(x_adj, transpose(F), b_adj; args...)
end

function linsolve(A,b,b_adj,::LU ;  args...)
    x = similar(b) ; x_adj = similar(b_adj)
    linsolve!(x,x_adj,A,b,b_adj,LU(); args...)
    return x , x_adj
end
  