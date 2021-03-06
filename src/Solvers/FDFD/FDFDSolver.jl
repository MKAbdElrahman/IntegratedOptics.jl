export solve! 

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



function solve! end
function (sim::Simulation)(::typeof(solve!); solver = LU(), args...)
    ls =  LinearSystem(sim)
    linsolve!(sim.E,ls.A,ls.b,solver;args...)
end
