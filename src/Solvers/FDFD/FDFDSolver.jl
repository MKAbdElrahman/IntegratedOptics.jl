export solve! 
export solve

export LinearSystem



include("Utils.jl")
include("Partial.jl")
include("Curl.jl")
include("CurlCurl.jl")

mutable struct LinearSystem
∇ₛxμⁱ∇ₛx::SparseMatrixCSC{CFloat}
k₀²ϵᵣ::SparseMatrixCSC{CFloat} 
A::SparseMatrixCSC{CFloat}
Q::SparseMatrixCSC{CFloat}
b::Vector{CFloat}
end

function LinearSystem(sim::Simulation)
     ∇ₛxμⁱ∇ₛx_M =  sim(∇ₛxμⁱ∇ₛx)
     ϵᵣ =    sim(convert_to_diagonal_matrix,:ϵᵣ)
     k₀²ϵᵣ = (2pi/sim.λ₀)^2 * ϵᵣ
     A =    ∇ₛxμⁱ∇ₛx_M - k₀²ϵᵣ
     Q   =   sim(convert_to_diagonal_matrix,:Q)
     src  =   sim(convert_to_vector,:J)
     b =  sim.activate_tfsf ?   (Q*A - A*Q) * src   : src   
     LinearSystem(∇ₛxμⁱ∇ₛx_M,k₀²ϵᵣ,A,Q,b)
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
    sim.E_x = sim(ExtractReshape(),e,x̂)
    sim.E_y = sim(ExtractReshape(),e,ŷ)
    sim.E_z = sim(ExtractReshape(),e,ẑ)
     h =  sim(μⁱ∇ₛx) * e
    sim.H_x = sim(ExtractReshape(),h,x̂)
    sim.H_y = sim(ExtractReshape(),h,ŷ)
    sim.H_z = sim(ExtractReshape(),h,ẑ)
end