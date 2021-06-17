using Photon

Nx = 20; Ny = 20;
λ = 1.55; 

dx = λ/Nx;dy = λ/Ny 

Lx = 10 * λ;
Ly = 10 * λ;

sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (dx,dy) ))
sim(setsrc!,ẑ,x -> 1 , x-> sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2) <=  dx)

#sim(setsrc!,PlaneWave(k̂ = (0.0, 2pi/λ), ê = (0,0,1) , a = 1))

sim(contourplot, :src_z, real ; xlabel = "x-axis", ylabel = "y-axis", title = "source x")

#sim(setTFSF! ,λ)
#sim(contourplot, :Q, real ; xlabel = "x-axis", ylabel = "y-axis", title = "TFSF")

sim(setpml!,1λ)
sim(contourplot, :S_y, imag ; xlabel = "x-axis", ylabel = "y-axis", title = "PML Y")
sim(contourplot, :S_x, imag ; xlabel = "x-axis", ylabel = "y-axis", title = "PML X")

sim(setϵᵣ!,x̂,x -> 8, x -> sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2) <=  1.5 )
sim(setϵᵣ!,ŷ,x -> 8, x -> sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2) <=  1.5 )
sim(setϵᵣ!,ẑ,x -> 8, x -> sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2) <=  1.5 )

sim(contourplot,  :ϵᵣ_xx, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")
sim(contourplot, :ϵᵣ_yy, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ y")
sim(contourplot, :ϵᵣ_zz, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ z")

Am = sim(A)
bv = sim(b)

x = Am \ bv
Ex,Ey,Ez = sim(reshapefield,x,Val(3))
sim(contourplot, Ez, imag ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")

#=
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