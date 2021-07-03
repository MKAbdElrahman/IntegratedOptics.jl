export ∂L∂ϵᵣ ,  ∂L∂ϵᵣ2

function ∂L∂E end
function (sim::Simulation)(::typeof(∂L∂E),objective_function::Function)
	∂L∂E_x = gradient(objective_function,sim)[1].x[:E_x]
    ∂L∂E_y = gradient(objective_function,sim)[1].x[:E_y]
    ∂L∂E_z = gradient(objective_function,sim)[1].x[:E_z]
    (∂L∂E_x,  ∂L∂E_y , ∂L∂E_z)
end

function ∂L∂ϵᵣ end
function (sim::Simulation)(::typeof(∂L∂ϵᵣ),objective_function::Function)
    #################
    # forward problem
    linearsystem = LinearSystem(sim)
	A = linearsystem.A
	E = A \ linearsystem.b
    # the forward problem solution must be written back to sim
	sim.E_x  = sim(Photon.extractreshape,E,x̂)
	sim.E_y  = sim(Photon.extractreshape,E,ŷ)
	sim.E_z  = sim(Photon.extractreshape,E,ẑ)
    ###########
    # adjoint problem
    ∂L∂E_x,  ∂L∂E_y , ∂L∂E_z = sim(∂L∂E,objective_function)
    _∂L∂E_ = [∂L∂E_x[:] ;  ∂L∂E_y[:] ; ∂L∂E_z[:]]
    A_adj = adjoint(A) 
	E_adj = A_adj \ _∂L∂E_
    ############
    # sensitivty
	∂L∂ϵᵣ = 2 * (2pi/sim.λ₀)^2 .* real.(E .* E_adj)
    ∂L∂ϵᵣ_xx = sim(Photon.extractreshape,∂L∂ϵᵣ,x̂)
	∂L∂ϵᵣ_yy = sim(Photon.extractreshape,∂L∂ϵᵣ,ŷ)
	∂L∂ϵᵣ_zz = sim(Photon.extractreshape,∂L∂ϵᵣ,ẑ) 
    ############
    # return
    ∂L∂ϵᵣ_xx , ∂L∂ϵᵣ_yy , ∂L∂ϵᵣ_zz
end

function ∂L∂ϵᵣ2 end

function (sim::Simulation)(::typeof(∂L∂ϵᵣ2),target)
    #################
    # forward problem
    linearsystem = LinearSystem(sim)
	A = linearsystem.A
	E = A \ linearsystem.b
    # the forward problem solution must be written back to sim
	sim.E_x  = sim(Photon.extractreshape,E,x̂)
	sim.E_y  = sim(Photon.extractreshape,E,ŷ)
	sim.E_z  = sim(Photon.extractreshape,E,ẑ)
    ###########
    # adjoint problem
   # ∂L∂E_x,  ∂L∂E_y , ∂L∂E_z = sim(∂L∂E,objective_function)
    target_x,target_y,target_z = target
    t = [target_x[:] ; target_y[:]; target_z[:]]
    _∂L∂E_ = conj.(t)
    A_adj = transpose(A) 
	E_adj = A_adj \ _∂L∂E_
    ############
    # sensitivty
	∂L∂ϵᵣ = 2 * (2pi/sim.λ₀)^2 .* real.(E .* E_adj)
    ∂L∂ϵᵣ_xx = sim(Photon.extractreshape,∂L∂ϵᵣ,x̂)
	∂L∂ϵᵣ_yy = sim(Photon.extractreshape,∂L∂ϵᵣ,ŷ)
	∂L∂ϵᵣ_zz = sim(Photon.extractreshape,∂L∂ϵᵣ,ẑ) 
    ############
    # return
    ∂L∂ϵᵣ_xx , ∂L∂ϵᵣ_yy , ∂L∂ϵᵣ_zz
end