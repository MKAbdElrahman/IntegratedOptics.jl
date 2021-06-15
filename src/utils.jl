function set!(m::AbstractArray,grid::Grid,valueF::Function,maskF::Function =  (x -> true) ,gridtype::GridType = p̂) 
	mask = maskF.(Coordinates(grid,gridtype))
	vals = valueF.(Coordinates(grid,gridtype));
	m[mask] = vals[mask];
	return nothing
end	

function add!(m::AbstractArray,grid::Grid,valueF::Function,maskF::Function =  (x -> true) ,gridtype::GridType = p̂) 
	mask = maskF.(Coordinates(grid,gridtype))
	vals = valueF.(Coordinates(grid,gridtype));
	m[mask] .+= vals[mask];
	return nothing
end	
