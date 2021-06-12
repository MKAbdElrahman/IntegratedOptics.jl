export Device, one_in_one_out_device! , updateRectangularRegion! 

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



function one_in_one_out_device!(device::Device,d,wd,hd)
    x0 , y0 = 0.5 .* device.grid.extent
    updateRectangularRegion!(device, 1.5 , ((-Inf,y0 - d/2) , (Inf, y0 + d/2)))
    updateRectangularRegion!(device, 1.25 ,((-hd/2+x0,-wd/2+y0) , (hd/2+x0, wd/2+y0)))
end
    

function updateRectangularRegion!(dev::Device{2},ϵᵣ , (p1 , p2))	
	wg((x,y)) =  p1[1] <= x <= p2[1]   && 	 p1[2] <= y <= p2[2]
	value((x,y)) =  ϵᵣ
	update!(dev.ϵᵣ11,dev.grid,wg,value)
	update!(dev.ϵᵣ22,dev.grid,wg,value)	
	update!(dev.ϵᵣ33,dev.grid,wg,value)	
end	

function update!(m::Array,grid::Grid,maskF::Function,valueF::Function)
	mask = maskF.(x⃗c(grid))
	vals = valueF.(x⃗c(grid));
	m[mask] = vals[mask];
	return nothing
end		