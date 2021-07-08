export update!



function update!(opt, x, x̄)
    x .-= apply!(opt, x, x̄)
end


function (sim::Simulation)(::typeof(update!),opt ,m::AbstractArray,vals::AbstractArray,maskF = EVERYWHERE ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
	m[mask] .+= vals[mask];	
    update!(opt,m[mask], vals[mask])
end




