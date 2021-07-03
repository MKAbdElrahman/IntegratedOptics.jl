using Photon

Si = Material(ϵᵣ = 3.64^2 )
SiO2 = Material(ϵᵣ = 1.45^2 )
Air = Material(ϵᵣ = 1.0^2 )


λ = 1.55;

Lx = 10.0 ; 
Ly = 8.0;

sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (0.07,0.07) ))
sim(setbackground!,SiO2)



w_d = 3
h_d = 3
design_region(x) = Cuboid(((.5(Lx - w_d) , .5(Ly - h_d)),(.5(Lx + w_d) , .5(Ly + h_d))))

sim(setmaterial!,Si,design_region)

sim(contourplot,:ϵᵣ,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")



Cuboid2(((0,0),(5,5)))((6,1))