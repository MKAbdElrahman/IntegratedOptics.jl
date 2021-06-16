export setTFSF!

struct TFSF end	
const  setTFSF! = TFSF()

function (sim::Simulation)(::TFSF, reg::Function, gridtype::GridType= p̂)
	sim(set!,sim.Q,x -> true,reg, gridtype)	
end
function (sim::Simulation)(::TFSF,dir::Direction{D},side::Low, thickness::Number,gridtype::GridType= p̂) where {D}		
    sim(set!,sim.Q,x -> true,x -> x[D] <= thickness, gridtype)		
end

function (sim::Simulation)(::TFSF,dir::Direction{D},side::High, thickness::Number,gridtype::GridType= p̂) where {D}		
    sim(set!,sim.Q,x -> true,x -> x[D] >= extent(sim.grid,dir)- thickness, gridtype)	
end
function (sim::Simulation)(t::TFSF,dir::Direction{D}, thickness::Number,gridtype::GridType= p̂) where {D}	
sim(t,dir,HIGH, thickness,gridtype)	
sim(t,dir,LOW, thickness,gridtype)	
end

function (sim::Simulation{1})(t::TFSF, thickness::Number,gridtype::GridType= p̂) 
sim(t,x̂, thickness,gridtype)	
end
function (sim::Simulation{2})(t::TFSF, thickness::Number,gridtype::GridType= p̂) 
sim(t,x̂, thickness,gridtype)	
sim(t,ŷ, thickness,gridtype)			
end	
function (sim::Simulation{3})(t::TFSF, thickness::Number,gridtype::GridType= p̂) 	
sim(t,x̂, thickness,gridtype)	
sim(t,ŷ, thickness,gridtype)	
sim(t,ẑ, thickness,gridtype)				
end	