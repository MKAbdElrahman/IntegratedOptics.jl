using Photon



λ = 1.55;
Lx = 10 * λ; 
sim = Simulation(λ₀ = λ ;  grid = Grid(extent = Lx , spacing =  λ/40 ))
sim(setpml!,λ)
sim(setsrc!, PlaneWave(k̂ = (2pi/λ,), ê = (0,0,1)))
sim(setTFSF!,3λ)
material = Material(ϵᵣ = 7.4)
inBarrier(x) = abs(x[1] - 0.5Lx[1]) < 0.5λ
sim(setmaterial!,material,inBarrier)
sim(solve!)
