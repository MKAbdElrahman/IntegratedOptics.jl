

struct Reshape end
struct Extract end
struct ExtractReshape end



function (sim::Simulation)(::ExtractReshape, F::AbstractVector, dir::Direction)
    f = sim(Extract(),F,dir)
        sim(Reshape(),f)
end

function (sim::Simulation)(::Reshape, F::AbstractVector)
    g = sim.grid
    F = reshape(F,size(g));
    return F
end


function (sim::Simulation)(::Extract, F::AbstractVector, dir::Direction{ND}) where ND
    g = sim.grid
    Nw = ncells(g);
    f =  F[((ND-1)*Nw +1) : (ND*Nw)];
end

