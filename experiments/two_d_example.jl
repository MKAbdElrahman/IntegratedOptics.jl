########################################################
using Photon
########################################################
λ = 1.55; 
Lx = 8 * λ;
Ly = 8 * λ;
sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (λ/30,λ/30) ))
#########################################################
#sim(setTFSF! ,1.5λ)
##########################################################
sim(setpml!,1λ)
##########################################################
#DesignRegion(x)    =  abs(x[1]-Lx/2) <=  3 && abs(x[2]-Ly/2) <=  3
WaveGuide(x) = abs(x[1]-Lx/2) <=  .5 #&& x[2] >= 0.5Ly
Si = Material(8,8,8)
sim(setmaterial!,Si,WaveGuide)
sim(contourplot,  :ϵᵣ, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")
###########################################################
## 
###########################################################
point =  (.5Lx,1.2λ)
sim_wg = sim(slice, ŷ , point)
#sim_wg(lineplot, :ϵᵣ_xx , real)
vals,vecs =  sim_wg(solve_for_modes)
vals ./ (2pi/λ)^2
ey_ex = vecs[:,1]   
ey,ex  = sim_wg(reshapefield,ey_ex,Val(2))
sim_wg(lineplot, ey, abs)
###########################################################
sim(attachmode!, ey , sim.J_z, ŷ , point)
###########################################################
x = sim(solve_with_FDFD,using_direct_solver)
Ex,Ey,Ez = sim(reshapefield,x,Val(3))
###########################################################
sim(contourplot,Ez, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
#sim(contourplot,Ey, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ey")
#sim(contourplot,Ex, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ex")
###########################################################
sim.J_x = Ex
sim.J_y = Ey
sim.J_z = Ez
###########################################
WaveGuide(x) = abs(x[1]-Lx/2) <=  2.5  &&   abs(x[2]-Ly/2) <=  2.5
Si = Material(8,8,8)
sim(setmaterial!,Si,WaveGuide)
sim(contourplot,  :ϵᵣ, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")
##########################################
sim(setTFSF! ,2.0λ)
x = sim(solve_with_FDFD,using_direct_solver)
#Ex,Ey,Ez = sim(reshapefield,x,Val(3))
#sim(contourplot,Ez, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
#sim(contourplot,Ey, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ey")
#sim(contourplot,Ex, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ex")