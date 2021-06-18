
export reshapefield

struct ReshapeField end
const reshapefield = ReshapeField();


function (sim::Simulation)(::ReshapeField, F::AbstractVector)
    ncomps = Int(length(F) / ncells(sim.grid))
    sim(reshapefield,F,Val{ncomps}())
end


function (sim::Simulation)(::ReshapeField, F::AbstractVector, ncomps::Val{3})
    g = sim.grid
    Nw = ncells(g);
    fx = @view F[1:Nw];
    fy = @view F[Nw+1:2Nw]
    fz = @view F[2Nw+1:3Nw]
    Fx = reshape(fx,size(g));
    Fy = reshape(fy,size(g));
    Fz = reshape(fz,size(g));
    return (Fx,Fy,Fz)
end

function (sim::Simulation)(::ReshapeField, F::AbstractVector, ncomps::Val{2})
    g = sim.grid
    Nw = ncells(g);
    fx = @view F[1:Nw];
    fy = @view F[Nw+1:2Nw]
    Fx = reshape(fx,size(g));
    Fy = reshape(fy,size(g));
    return (Fx,Fy)
end



function (sim::Simulation)(::ReshapeField, F::AbstractVector, ncomps::Val{1})
    g = sim.grid
    Fx = reshape(F,size(g));
    return Fx
end
