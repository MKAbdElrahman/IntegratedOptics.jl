export TargetObjective

abstract type ObjectiveType end	
# All objectives are expected to implement a vec() and adjoint_src() methods
# and objective_value

mutable struct TargetObjective{T,N} <: ObjectiveType
    x::Array{T,N}
    y::Array{T,N}
    z::Array{T,N}
end

adjoint_src(objective::TargetObjective) = conj.(vec(objective)) / norm(vec(objective))

objective_value(objective::TargetObjective,x) = dot(vec(objective),x) / norm(vec(objective))^2

Base.vec(t::TargetObjective) = [vec(t,x̂);vec(t,ŷ); vec(t,ẑ)]
Base.vec(t::TargetObjective,dir::Direction) = vec(component(t,dir))

component(t::TargetObjective,dir::Direction{1}) = t.x
component(t::TargetObjective,dir::Direction{2}) = t.y
component(t::TargetObjective,dir::Direction{3}) = t.z

