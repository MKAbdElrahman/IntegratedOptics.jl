

struct Reshape end
struct Extract end
struct ExtractReshape end

#=
export reshapefield

struct ReshapeField end
const reshapefield = ReshapeField();


function (sim::Simulation)(::ReshapeField, F::AbstractVector)
    ncomps = Int(length(F) / ncells(sim.grid))
    sim(reshapefield,F,Val{ncomps}())
end




function (sim::Simulation)(::ReshapeField, F::AbstractVector, ncomps::Val{3})
 
    Fx = sim(Reshape(),sim(Extract(),F,x̂))
    Fy = sim(Reshape(),sim(Extract(),F,ŷ))
    Fz = sim(Reshape(),sim(Extract(),F,ẑ))

    return (Fx,Fy,Fz)
end

function (sim::Simulation)(::ReshapeField, F::AbstractVector, ncomps::Val{2})
   Fx = sim(Reshape(),sim(Extract(),F,x̂))
   Fy = sim(Reshape(),sim(Extract(),F,ŷ))
        return (Fx,Fy)
end

function (sim::Simulation)(::ReshapeField, F::AbstractVector, ncomps::Val{1})
    Fx = sim(Reshape(),sim(Extract(),F,x̂))
         return (Fx,)
 end
 =#


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

