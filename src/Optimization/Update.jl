export update!



function update! end


function (sim::Simulation)(::typeof(update!),opt ,m::AbstractArray,vals::AbstractArray,maskF = EVERYWHERE ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
    m[mask] .+= apply!(opt, m, vals)[mask]
end




