export solve! 
export solve

export LinearSystem



include("Utils.jl")
include("Partial.jl")
include("Curl.jl")
include("CurlCurl.jl")

mutable struct LinearSystem
∇ₛxμⁱ∇ₛx::SparseMatrixCSC{CFloat}
ϵᵣ::Vector{CFloat}
A::SparseMatrixCSC{CFloat}
Q::SparseMatrixCSC{CFloat}
b::Vector{CFloat}
end

function LinearSystem(sim::Simulation)
     ∇ₛxμⁱ∇ₛx_M =  sim(∇ₛxμⁱ∇ₛx)
     ϵᵣ =    sim(convert_to_vector,:ϵᵣ)
     k₀²ϵᵣ = spdiagm(0 => (2pi/sim.λ₀)^2 * ϵᵣ)
     A =     ∇ₛxμⁱ∇ₛx_M - k₀²ϵᵣ
     Q   =   sim(convert_to_diagonal_matrix,:Q)
     src  =   sim(convert_to_vector,:J)
     b =  sim.activate_tfsf ?   (Q*A - A*Q) * src   : src   
     LinearSystem(∇ₛxμⁱ∇ₛx_M,ϵᵣ,A,Q,b)
end



function solve!(x::AbstractVector,linearsystem::LinearSystem ; linearsolver::AbstractLinearSolver = LU())  
      linsolve!(x,linearsystem.A,linearsystem.b,linearsolver)
      return nothing
end


function solve(linearsystem::LinearSystem  ;  linearsolver::AbstractLinearSolver = LU()) 
     x = similar(linearsystem.b) 
     linsolve!(x,linearsystem.A,linearsystem.b,linearsolver)
     return x
end

function (sim::Simulation)(::typeof(solve!);linearsolver::AbstractLinearSolver = LU())
    e = solve(LinearSystem(sim),linearsolver = linearsolver)
    sim.E_x = sim(extractreshape,e,x̂)
    sim.E_y = sim(extractreshape,e,ŷ)
    sim.E_z = sim(extractreshape,e,ẑ)
end
