########################################################
using Photon
########################################################
λ = 1.55; 
Lx = 10 * λ;
Ly = 10 * λ;
sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (λ/20,λ/20) ))
#########################################################
sim(setsrc!,PlaneWave(k̂ = (0.0, 2pi/λ), ê = (0,0,1) , a = 1))
#sim(contourplot, :src_z, real ; xlabel = "x-axis", ylabel = "y-axis", title = "source x")
#########################################################
sim(setTFSF! ,1.5λ)
#sim(contourplot, :Q, real ; xlabel = "x-axis", ylabel = "y-axis", title = "TFSF")
##########################################################
sim(setpml!,1λ)
##########################################################
Rectangle(x) =  abs(x[1]-Lx/2) <=  3 && abs(x[2]-Ly/2) <=  1.5
Si = Material(2,2,2)
sim(setmaterial!,Si,Rectangle)
#sim(contourplot,  :ϵᵣ_xx, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")
###########################################################
x = sim(solve_with_FDFD,using_direct_solver)
Ex,Ey,Ez = sim(reshapefield,x,Val(3))
#sim(contourplot, Ez, imag ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
###########################################################
