export Simulation

include("Grid.jl")	

Base.@kwdef mutable struct Simulation{Dim}

		grid::Grid{Dim}
		
		λ₀::Float

		J_x::Array{CFloat,Dim} = zeros(CFloat,size(grid))
		J_y::Array{CFloat,Dim} = zeros(CFloat,size(grid))
		J_z::Array{CFloat,Dim} = zeros(CFloat,size(grid))
		
		Q::BitArray{Dim}	 = falses(size(grid))
		
		S_x::Array{CFloat,Dim} = ones(CFloat,size(grid))
		S_y::Array{CFloat,Dim} = ones(CFloat,size(grid))
		S_z::Array{CFloat,Dim} = ones(CFloat,size(grid))
		
		activate_tfsf::Bool = false

		
		ϵᵣ_xx::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		ϵᵣ_yy::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		ϵᵣ_zz::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		
		μᵣ_xx::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		μᵣ_yy::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		μᵣ_zz::Array{CFloat,Dim}  = ones(CFloat,size(grid))

        e⁻ⁱᵏᴸ::NTuple{Dim,CFloat} = ntuple(i -> CFloat(1.0 + 0.0im) , dimension(grid))

		E::Vector{CFloat}  = zeros(CFloat,3 * ncells(grid))
	end
	
function Base.show(io::IO, sim::Simulation{Dim}) where {Dim}
        print(io, "A $(Dim)D Simulation is initialized.\n")
end	




function (sim::Simulation)(sym::Symbol,dir::Direction, maskF::Function) 
	mat = sim(sym,dir) 
	mask = maskF.(Coordinates(sim.grid,p̂))
	mat[mask]
end




include("GridDerivatives.jl")
include("Set.jl")
include("Get.jl")
include("Add.jl")
include("Geometry.jl")
include("Material.jl")
include("TFSF.jl")
include("PML.jl")
include("Sources/Source.jl")
include("BC.jl")
include("SliceSimulation.jl")

