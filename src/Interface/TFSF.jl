export setTFSF!

function  setTFSF! end

function (sim::Simulation)(::typeof(setTFSF!), reg::Function, gridtype::GridType= p̂)
	sim(set!,sim.Q,x -> true,reg, gridtype)	
    sim.activate_tfsf = true;
end
function (sim::Simulation)(::typeof(setTFSF!),dir::Direction{D},side::Low, thickness::Number,gridtype::GridType= p̂) where {D}		
    sim(set!,sim.Q,x -> true,x -> x[D] <= thickness, gridtype)		
    sim.activate_tfsf = true;
end

function (sim::Simulation)(::typeof(setTFSF!),dir::Direction{D},side::High, thickness::Number,gridtype::GridType= p̂) where {D}		
    sim(set!,sim.Q,x -> true,x -> x[D] >= extent(sim.grid,dir)- thickness, gridtype)	
    sim.activate_tfsf = true;
end
function (sim::Simulation)(::typeof(setTFSF!),dir::Direction{D}, thickness::Number,gridtype::GridType= p̂) where {D}	
sim(setTFSF!,dir,HIGH, thickness,gridtype)	
sim(setTFSF!,dir,LOW, thickness,gridtype)	
end

function (sim::Simulation{1})(::typeof(setTFSF!), thickness::Number,gridtype::GridType= p̂) 
sim(setTFSF!,x̂, thickness,gridtype)	
end
function (sim::Simulation{2})(::typeof(setTFSF!), thickness::Number,gridtype::GridType= p̂) 
sim(setTFSF!,x̂, thickness,gridtype)	
sim(setTFSF!,ŷ, thickness,gridtype)			
end	
function (sim::Simulation{3})(::typeof(setTFSF!), thickness::Number,gridtype::GridType= p̂) 	
sim(setTFSF!,x̂, thickness,gridtype)	
sim(setTFSF!,ŷ, thickness,gridtype)	
sim(setTFSF!,ẑ, thickness,gridtype)				
end	