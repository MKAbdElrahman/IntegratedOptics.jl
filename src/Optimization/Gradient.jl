export f_∇f

function f_∇f(objective::ObjectiveType,sim::Simulation)
	linsys = LinearSystem(sim)
	A = lu(linsys.A)
	b = linsys.b
	x = similar(b)
	ldiv!(x, A , b)
	x_adj = similar(b)
    ldiv!(x_adj, transpose(A), adjoint_src(objective))

    ∇ = normalize(2 * (2pi/sim.λ₀)^2 * real(x .* x_adj))

    ∇ϵx = sim(extractreshape,∇,x̂)
    ∇ϵy = sim(extractreshape,∇,ŷ)
    ∇ϵz = sim(extractreshape,∇,ẑ)

    sim.E = x
	return objective_value(objective,x) , Dict([(x̂, ∇ϵx), (ŷ, ∇ϵy),(ẑ,∇ϵz)])

end