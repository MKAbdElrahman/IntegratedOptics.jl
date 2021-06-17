using Photon


Nx = 40; 
dx = 1.55/Nx;
Lx = 16 * 1.55;

sim = Simulation(λ₀ = 1.55 ;  grid = Grid(extent = Lx , spacing =  dx ))

sim(setsrc!,ẑ,x -> 1 , x-> abs(x[1] - 0.5Lx[1]) < 1.5dx)
sim(lineplot,:src_z,real)

unique(sim.src_z)
sim(setTFSF! ,4pi)
#sim(lineplot,:Q,real)
sim(setpml!,3*1.55)
sim(lineplot,:S_x,imag)


sim(setϵᵣ!,x̂,x -> 1, x ->  abs(x[1] -  0.5Lx) <=  2*1.55 )
sim(setϵᵣ!,ŷ,x -> 1, x ->  abs(x[1] -  0.5Lx) <=  2*1.55 )
sim(setϵᵣ!,ẑ,x -> 1, x ->  abs(x[1] -  0.5Lx) <=  2*1.55 )

#sim(lineplot,:ϵᵣ_xx,real)

Am = sim(A)
#Amm =    sim(Photon.∇ₛxμⁱ∇ₛx) - sim(Photon.ϵᵣI)
bv = sim(b)
x = Am \ bv

Ex,Ey,Ez = sim(reshapefield,x,Val(3))

sim(lineplot,Ez,real)