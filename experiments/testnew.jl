using Revise
using Photon

grid = Grid(extent = (1,1) , spacing = (.01,.01));

device = Device(grid);  
one_in_one_out_device!(device,0.05,0.4,.4)

pml =PML(grid)(x̂,HIGH,20)

contour(pml,grid, imag)
contour(device.ϵᵣ11,grid, real)