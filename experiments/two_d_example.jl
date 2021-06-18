########################################################
using Photon
########################################################
λ = 1.55; 
Lx = 10 * λ;
Ly = 10 * λ;
sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (λ/20,λ/20) ))
#########################################################
#sim(setsrc!,PlaneWave(k̂ = (0.0, 2pi/λ), ê = (0,0,1) , a = 1))
#sim(contourplot, :src_z, real ; xlabel = "x-axis", ylabel = "y-axis", title = "source x")
#########################################################
#sim(setTFSF! ,1.5λ)
#sim(contourplot, :Q, real ; xlabel = "x-axis", ylabel = "y-axis", title = "TFSF")
##########################################################
sim(setpml!,1λ)
##########################################################
#DesignRegion(x)    =  abs(x[1]-Lx/2) <=  3 && abs(x[2]-Ly/2) <=  3
InputWaveGuide(x)  = abs(x[1]-Lx/2) <=  .5 && x[2] <= 0.5Ly
OutputWaveGuide(x) = abs(x[1]-Lx/2) <=  .5 && x[2] >= 0.5Ly

Si = Material(2,2,2)
#sim(setmaterial!,Si,DesignRegion)
sim(setmaterial!,Si,InputWaveGuide)
sim(setmaterial!,Si,OutputWaveGuide)

sim(contourplot,  :ϵᵣ_xx, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")
###########################################################
sim_wg = sim(slice, ŷ , (.5Lx,4))
#sim_wg(lineplot, :ϵᵣ_xx , real)
vals,vecs =  sim_wg(solve_for_modes)
ey_ex = vecs[:,1]   
mode  = sim_wg(reshapefield,ey_ex,Val(2))

function (sim::Simulation{Dim})(::AttachMode, mode  ,dir::Direction{D}, point::NTuple{Dim})
    ind = CartesianIndex(sim.grid,p̂,p)[D]

    input_x = selectdim(sim.src_x, D , ind)
    input_y = selectdim(sim.src_y, D , ind)

    ey,ex = mode

    input_x .= ex
    input_y .= ey
    
end

sim_wg(lineplot,TE,real)
input = selectdim(sim.src_x,2, 50 ) 
input .= TE
x = sim(solve_with_FDFD,using_direct_solver)
Ex,Ey,Ez = sim(reshapefield,x,Val(3))
sim(contourplot,Ex, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")


############################################################
x = sim(solve_with_FDFD,using_direct_solver)
Ex,Ey,Ez = sim(reshapefield,x,Val(3))
#sim(contourplot, Ez, imag ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
###########################################################



