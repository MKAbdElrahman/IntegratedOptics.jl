export add!

function add! end

function (sim::Simulation)(::typeof(add!),m::AbstractArray,valueF::Function,maskF = EVERYWHERE ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
	vals = valueF.(Coordinates(sim.grid,gridtype));
	m[mask] .+= vals[mask];	
end

function (sim::Simulation)(::typeof(add!),m::AbstractArray,vals::AbstractArray,maskF = EVERYWHERE ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
	m[mask] .+= vals[mask];	
end
