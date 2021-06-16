struct SimulationSetter end
const set! = SimulationSetter()

struct SimulationAdder end
const add! = SimulationAdder()

function (sim::Simulation)(::SimulationAdder,m::AbstractArray,valueF::Function,maskF::Function =  (x -> true) ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
	vals = valueF.(Coordinates(sim.grid,gridtype));
	m[mask] .+= vals[mask];	
end

function (sim::Simulation)(::SimulationSetter,m::AbstractArray,valueF::Function,maskF::Function =  (x -> true) ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
	vals = valueF.(Coordinates(sim.grid,gridtype));
	m[mask] = vals[mask];	
end