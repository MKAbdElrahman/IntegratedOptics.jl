
using Photon

λ = 1.55;

Lx =  λ; 
Ly =  λ;
Lz =  8λ;


sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly,Lz) , spacing =  (λ/15,λ/15,λ/15) ))

sim(setpml!,ẑ,λ)


sim(setsrc!, PlaneWave(k̂ = (0,0,2pi/λ), ê = (0,1,0)))

sim(setTFSF! , ẑ, 1.1λ)


material = Material(ϵᵣ = 13.491 + 0.036730im )

inSphere(x) = sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2+(x[3]-Lz/2)^2)  <=  1.2 

sim(setmaterial!,material,inSphere)

sim(solve!)
