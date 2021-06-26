export setsrc!

function  setsrc! end

function get_src_comp(sim::Simulation{Dim},  dir::Direction{D}) where {D,Dim}
	if D == 1 return sim.J_x end
	if D == 2 return sim.J_y end
	if D == 3 return sim.J_z end
end

function (sim::Simulation)(::typeof(setsrc!),dir::Direction,src::AbstractArray)
  get_src_comp(sim,  dir) = src
end

###################
function (sim::Simulation)(::typeof(setsrc!),dir::Direction,val::Function, reg::Function = (x -> true) , gridtype::GridType= p̂) 
  sim(set!, get_src_comp(sim,  dir) , val,reg,gridtype)	
end	

include("PlaneWave.jl")