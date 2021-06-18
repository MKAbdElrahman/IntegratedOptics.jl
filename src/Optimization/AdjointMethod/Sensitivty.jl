export sensitivity

struct Sensitivity end

const  sensitivity  = Sensitivity()

function (sim::Simulation)(::Sensitivity,obj::Function,ls::AbstractLinearSolver)
    A = sim(system_matrix)
    b = sim(source_vector)
    Q = sim(tfsf)
    Ex,Ey,Ez = sim(reshapefield,sim.activate_tfsf ? linsolve(A,(Q*A - A*Q)*b ,ls) :   linsolve(A,b,ls))
    Aᵃ = adjoint(A) 
    ∂L∂Ex , ∂L∂Ey , ∂L∂Ez = gradient(obj,Ex,Ey,Ez)
    bᵃ = [∂L∂Ex[:] ; ∂L∂Ey[:] ; ∂L∂Ez[:]]
    xᵃ =  linsolve(Aᵃ,bᵃ,ls)
    sens = sim(convert_to_vector,:ϵᵣ) .* xᵃ .*  [ Ex[:] ; Ey[:]; Ez[:] ]
    sim(reshapefield,sens)
end