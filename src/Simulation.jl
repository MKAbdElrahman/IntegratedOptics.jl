export Simulation
	Base.@kwdef mutable struct Simulation{Dim}
        
		grid::Grid{Dim}
		
		src_x::Array{CFloat,Dim} = zeros(CFloat,size(grid))
		src_y::Array{CFloat,Dim} = zeros(CFloat,size(grid))
		src_z::Array{CFloat,Dim} = zeros(CFloat,size(grid))
		
		Q::BitArray{Dim}	 = falses(size(grid))
		
		S_x::Array{CFloat,Dim} = ones(CFloat,size(grid))
		S_y::Array{CFloat,Dim} = ones(CFloat,size(grid))
		S_z::Array{CFloat,Dim} = ones(CFloat,size(grid))
		
		
		ϵᵣ_xx::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		ϵᵣ_yy::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		ϵᵣ_zz::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		
		μᵣ_xx::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		μᵣ_yy::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		μᵣ_zz::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		
	end
	
function Base.show(io::IO, sim::Simulation{Dim}) where {Dim}
        print(io, "A $(Dim)D Simulation is initialized.\n")
end	