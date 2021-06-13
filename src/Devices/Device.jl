export Device

mutable struct Device{N}
		
	ϵᵣ11::Array{CFloat,N}
	ϵᵣ22::Array{CFloat,N}
	ϵᵣ33::Array{CFloat,N}
		
	μᵣ11::Array{CFloat,N}
	μᵣ22::Array{CFloat,N}
	μᵣ33::Array{CFloat,N}
		
	grid::Grid{N}	

end

function Device(grid::Grid;  ϵᵣ::Number = 1.0, μᵣ::Number = 1.0)
	be   = fill(ϵᵣ  * one(CFloat),size(grid))
	bm   = fill(μᵣ  * one(CFloat),size(grid))
	return Device(be,be,be,bm,bm,bm,grid)	
end




function update!(m::AbstractArray,grid::Grid,maskF::Function,valueF::Function,gridtype::GridType{T} = p̂) where T
	mask = maskF.(Coordinates(grid,gridtype))
	vals = valueF.(Coordinates(grid,gridtype));
	m[mask] = vals[mask];
	return nothing
end		