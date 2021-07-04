export Optimization




mutable struct Optimization 
    sim
    ∂L∂x
    linsys
    x
    x_adj
    Δ
end
    
function Optimization(sim,target)
    ∂L∂x  = conj.([vec(target[1]) ; vec(target[2]); vec(target[3])])
    linsys = LinearSystem(sim) 
    x =     similar(linsys.b)
    x_adj = similar(linsys.b)
    Δ =     similar(linsys.b)
    return Optimization(sim,∂L∂x,linsys,x,x_adj,Δ)
end
    

include("Gradient.jl")
include("Optimisers.jl")
include("Update.jl")
include("Overlap.jl")
include("BoxConstraint.jl")