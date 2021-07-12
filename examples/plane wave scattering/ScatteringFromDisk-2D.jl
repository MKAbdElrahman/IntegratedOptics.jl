using  Photon
λ = 1.55;
Lx = 8 * λ; 
Ly = 8 * λ;
sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (λ/15,λ/15) ))
sim(setpml!,λ)
sim(setsrc!, PlaneWave(k̂ = (0,2pi/λ), ê = (0,0,1)))
sim(setTFSF! ,1.1λ)
Si = Material(ϵᵣ = 2.0 )
Rect(x) =  abs(x[2]-Ly/2) <=  λ/2 
sim(setmaterial!,Si,Rect);
sim(solve!)

