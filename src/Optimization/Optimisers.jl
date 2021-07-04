export Ascent , apply!

abstract type AbstractOptimiser end

mutable struct Ascent <: AbstractOptimiser
    α::Float64
end

function apply! end
function (opt::Optimization)(::typeof(apply!),o::Ascent)
    opt.Δ .*=  o.α 
end
