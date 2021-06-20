
using Photon

λ = 1.55;

Lx = 6 * λ; 
Ly = 6 * λ;
Lz = 6 * λ;


sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly,Lz) , spacing =  (λ/10,λ/10,λ/10) ))

sim(setpml!,λ)


sim(setsrc!, PlaneWave(k̂ = (0,2pi/λ,0), ê = (0,0,1)))

sim(setTFSF! ,1.5λ)


material = Material(ϵᵣ = 13.491 + 0.036730im )

inSphere(x) = sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2+(x[3]-Lz/2)^2)  <=  1.2 

sim(setmaterial!,material,inSphere)


Ex,Ey,Ez  = sim(solve_with_FDFD,using_gmres)

