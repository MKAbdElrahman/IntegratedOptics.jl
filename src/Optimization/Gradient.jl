export gradient!

function gradient! end

function (opt::Optimization)(::typeof(gradient!))
    F = lu(opt.linsys.A)
    # forward problem
    ldiv!(opt.x, F , opt.linsys.b)
    # adjoint problem
    ldiv!(opt.x_adj, transpose(F), opt.∂L∂x)
    opt.Δ .= real.(opt.x .* opt.x_adj) 
    opt.Δ .= opt.Δ /  findmax(real.(opt.Δ))[1]
end

