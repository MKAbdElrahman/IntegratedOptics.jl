#=
export sensitivity!

function sensitivity! end

function (sim::Simulation)(::typeof(sensitivity!),objective_function::Function)
    grad_E  = gradient(objective_function,sim)[1].x[:E]
    sim(adjointsolve!,grad_E)
    sim.sensitivity = sim(convert_to_vector,:ϵᵣ) .* sim.E .*  sim.E_adjoint 
end
=#