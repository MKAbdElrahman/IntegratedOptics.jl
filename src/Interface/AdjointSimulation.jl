export adjointsolve!

function adjointsolve! end

mutable struct AdjointSimulation

	Ja_x::Array{CFloat,Dim} 
	Ja_y::Array{CFloat,Dim} 
	Ja_z::Array{CFloat,Dim} 

    E_adjoint::Vector{CFloat}
end


function AdjointSimulation(sim::Simulation,Edjoint::AbstractVector{CFloat})

end


function (asim::AdjointSimulation)(::typeof(adjointsolve!), sim; linearsolver::AbstractLinearSolver = LU())      
    linsolve!(asim.E_adjoint,adjoint(sim.sysetm_matrix),adjointsrc,linearsolver)
    return nothing
end

