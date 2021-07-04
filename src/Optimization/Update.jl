export update!

function update! end

function (opt::Optimization)(::typeof(update!),region)
    s = mask(opt.sim,region)
    opt.Δ .= s .* opt.Δ
    opt.linsys.ϵᵣ .+=   opt.Δ
    opt.linsys.A .=   opt.linsys.∇ₛxμⁱ∇ₛx - spdiagm(0 => (2pi/opt.sim.λ₀)^2 * opt.linsys.ϵᵣ)

end

function mask(sim,maskF)
    m =  vec(maskF.(Coordinates(sim.grid,p̂)))
    return [m;m;m]
 end