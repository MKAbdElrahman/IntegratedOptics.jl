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




function update!(m::Array,grid::Grid,maskF::Function,valueF::Function)
	mask = maskF.(x⃗c(grid))
	vals = valueF.(x⃗c(grid));
	m[mask] = vals[mask];
	return nothing
end		