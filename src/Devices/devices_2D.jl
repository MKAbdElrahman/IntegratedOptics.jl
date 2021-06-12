
export  one_in_one_out_device! , updateRectangularRegion! 

function one_in_one_out_device!(device::Device{2},d,wd,hd)
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