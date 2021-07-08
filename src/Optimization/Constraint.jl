# crude method for binarization and being with limit
# they work great!
# need some crude  filters also :D 

export boxconstraint!
export gradualbinarize!

function boxconstraint! end
function (sim::Simulation)(::typeof(boxconstraint!),m::AbstractArray,rng,maskF = EVERYWHERE ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
    for i in eachindex(m)
        if real(m[i]) < rng[1] && mask[i]  m[i] = rng[1] end
        if real(m[i]) > rng[2] && mask[i]  m[i] = rng[2] end
    end
end


function gradualbinarize! end

function (sim::Simulation)(::typeof(gradualbinarize!),m::AbstractArray,rng,δ,maskF = EVERYWHERE ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
    for i in eachindex(m)
        if real(m[i] - rng[1]) < δ && mask[i]  m[i] = rng[1] end
        if real(rng[2] - m[i]) < δ && mask[i]  m[i] = rng[2] end
    end
end
