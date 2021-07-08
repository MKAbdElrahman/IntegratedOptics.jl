export set!
function set! end
function (sim::Simulation)(::typeof(set!),m::AbstractArray,valueF::Function,maskF =  EVERYWHERE,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
	vals = valueF.(Coordinates(sim.grid,gridtype));
	m[mask] = vals[mask];	
end

