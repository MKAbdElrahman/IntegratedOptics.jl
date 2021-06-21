export sensitivity

struct Sensitivity end

const  sensitivity  = Sensitivity()

function (sim::Simulation)(::Sensitivity,obj::Function,ls::AbstractLinearSolver = LU())
   # Ex,Ey,Ez = sim.Ex , sim.Ey , sim.Ez
   #Aᵃ = adjoint(sim.A) 
    #∂L∂Ex , ∂L∂Ey , ∂L∂Ez = gradient(obj,Ex,Ey,Ez)
    #bᵃ = [∂L∂Ex[:] ; ∂L∂Ey[:] ; ∂L∂Ez[:]]
    #xᵃ =  linsolve(Aᵃ,bᵃ,ls)
    #sens = sim(convert_to_vector,:ϵᵣ) .* xᵃ .*  [ Ex[:] ; Ey[:]; Ez[:] ]
    #(obj(Ex,Ey,Ez),sim(reshapefield,sens))
end

function (sim::Simulation)(::Sensitivity,obj::Function,sym::Symbol)
    gradient(obj,sim)[1].x[sym]
end