export setϵᵣ! ,  setμᵣ! 

struct ϵᵣ end
struct μᵣ end

const  setϵᵣ! =  ϵᵣ()
const  setμᵣ! =  μᵣ()


function get_ϵ_comp(sim::Simulation{Dim},  dir::Direction{D}) where {D,Dim}
	if D == 1 return sim.ϵᵣ_xx end
	if D == 2 return sim.ϵᵣ_yy end
	if D == 3 return sim.ϵᵣ_zz end
end

function get_μ_comp(sim::Simulation{Dim},  dir::Direction{D}) where {D,Dim}
	if D == 1 return sim.μᵣ_xx end
	if D == 2 return sim.μᵣ_yy end
	if D == 3 return sim.μᵣ_zz end
end	

function (sim::Simulation)(::ϵᵣ,dir::Direction,val::Function, reg::Function = (x -> true) , gridtype::GridType= p̂) 
set!( get_ϵ_comp(sim,  dir),sim.grid,val,reg,gridtype)	
end		

function (sim::Simulation)(::μᵣ,dir::Direction,val::Function, reg::Function = (x -> true) , gridtype::GridType= p̂) 
set!( get_μ_comp(sim,  dir),sim.grid,val,reg,gridtype)	
end		