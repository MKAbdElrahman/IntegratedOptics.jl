using Photon

λ = 1.55;

Lx = 6 * λ; 
Ly = 6 * λ;

sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (λ/30,λ/30) ))

sim(setpml!,λ)


sim(setsrc!, PlaneWave(k̂ = (0,2pi/λ), ê = (0,0,1)))
#sim(contourplot,:J,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")


sim(setTFSF! ,1.5λ)


Silver = Material(ϵᵣ = 13.491 + 0.036730im )

Disk(x) = sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2)  <=  1.2 

sim(setmaterial!,Silver,Disk)

#sim(contourplot,  :ϵᵣ, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")

 sim(init!)
 sim(solve!)

sim(contourplot,:E, ẑ, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")

