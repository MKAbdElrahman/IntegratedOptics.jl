export f_∇f

function f_∇f(objective::ObjectiveType,sim::Simulation ; solver  = LU() , args...)
	linsys = LinearSystem(sim)
	A ,b = linsys.A , linsys.b
	
    x , x_adj = linsolve(A,b,adjoint_src(objective), solver ; args...)

    ∇ = normalize(2 * (2pi/sim.λ₀)^2 * real(x .* x_adj),Inf)

    ∇ϵx = sim(extractreshape,∇,x̂)
    ∇ϵy = sim(extractreshape,∇,ŷ)
    ∇ϵz = sim(extractreshape,∇,ẑ)

    sim.E = x
	return objective_value(objective,x) , Dict([(x̂, ∇ϵx), (ŷ, ∇ϵy),(ẑ,∇ϵz)])

end