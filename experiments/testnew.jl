using Photon

grid = Grid(extent = (1,1) , spacing = (.01,.01));

device = Device(grid);  
one_in_one_out_device!(device,10,0.05,0.4,.4)

pml =PML(grid)(x̂)

contour(pml,grid, imag)
contour(device.ϵᵣ11,grid, real)


vals , vecs = eigensolve(device,  k = 15 , direction = x̂, center = (.1,.5))

using Gnuplot
@gp real.(vecs[:,1]) "with lines"