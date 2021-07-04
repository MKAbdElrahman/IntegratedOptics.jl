export boxconstraint!

function boxconstraint! end


function (opt::Optimization)(::typeof(boxconstraint!),region,mn,mx)
    s = mask(opt.sim,region)
    for i in eachindex(s) 
        if s[i] && real(opt.linsys.ϵᵣ[i]) > mx  opt.linsys.ϵᵣ[i] = mx end
        if s[i] && real(opt.linsys.ϵᵣ[i]) < mn  opt.linsys.ϵᵣ[i] = mn end
    end
end

