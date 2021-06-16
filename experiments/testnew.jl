using Photon

Nx = 20; Ny = 20;
dx = 2pi/Nx; dy = 2pi/Ny
Lx = 8 * 2pi; Ly =  8 *  2pi

sim = Simulation(grid = Grid(extent = (Lx, Ly), spacing = (dx,dy)))
sim(setsrc!,PlaneWave(k̂ = (0.0, 1.0), ê = (0,0,1) , a = 1))


sim(contourplot, :src_z, real ; xlabel = "x-axis", ylabel = "y-axis", title = "source x")

sim(setTFSF! ,3pi)
sim(contourplot, :Q, real ; xlabel = "x-axis", ylabel = "y-axis", title = "TFSF")

sim(setpml!,3pi)
sim(contourplot, :S_y, imag ; xlabel = "x-axis", ylabel = "y-axis", title = "PML Y")
sim(contourplot, :S_x, imag ; xlabel = "x-axis", ylabel = "y-axis", title = "PML X")

sim(setϵᵣ!,x̂,x -> 8, x -> sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2) <=  1.5pi )
sim(setϵᵣ!,ŷ,x -> 8, x -> sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2) <=  1.5pi )
sim(setϵᵣ!,ẑ,x -> 8, x -> sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2) <=  1.5pi )

sim(contourplot,  :ϵᵣ_xx, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")
sim(contourplot, :ϵᵣ_yy, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ y")
sim(contourplot, :ϵᵣ_zz, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ z")
#=
Am = sim(A)
Amm =    sim(Photon.∇ₛxμⁱ∇ₛx) - sim(Photon.ϵᵣI)
bv = sim(b)



using SparseArrays
O = spzeros(ncells(sim.grid),ncells(sim.grid));

Q = spdiagm(sim.Q[:])
QM =  [ Q     O       O;
O      Q     O;
O      O     Q
]
bb = (Am * QM - QM * Am) * bv
x = Am \ bb
#(Ex, Ey,Ez) = sim(reshape_vector_field,x)
#sim(contourplot, Ez, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
#sim(contourplot, Ey, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ey")
#

=#