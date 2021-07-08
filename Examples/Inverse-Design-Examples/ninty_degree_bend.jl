using Photon

######################## MATERIALS ########################
Si =   Material(ϵᵣ = 3.64^2 )
SiO2 = Material(ϵᵣ = 1.45^2 )
Fg = Material(ϵᵣ = .6*(1.45^2 + 3.46^2) )
##########################################################

######################## SIMULATION #######################
λ₀ = 1.55
Lx , Ly =  λ₀ .* (4 , 4)
n_max = 3.64 
n_min = 1.45 
dx , dy = (λ₀/15/n_max) .* (1, 1)
sim = Simulation(λ₀ = 1.55 ;  grid = Grid(extent = (Lx,Ly) , spacing =  (dx,dy) ))
sim(setpml!,1.0)

##########################################################
###################### BUILD DEVICE ######################
#--------------------------------------------------------#
sim(setbackground!,SiO2)
#--------------------------------------------------------#
w_d = 1.2
h_d = 1.2
design_region = Cuboid(((.5(Lx - w_d) , .5(Ly - h_d)),(.5(Lx + w_d) , .5(Ly + h_d))))
sim(setmaterial!,Fg, design_region)
#--------------------------------------------------------#
h_wg_in = 0.5
input_waveguide  = Cuboid(((0 , .5(Ly - h_wg_in)),(.5(Lx) , .5(Ly + h_wg_in))))
sim(setmaterial!,Si,input_waveguide)
#--------------------------------------------------------#
w_wg_out = 0.5
output_waveguide  = Cuboid(((.5(Lx - w_wg_out),0),(.5(Lx + w_wg_out),.5Ly)))
sim(setmaterial!,Si,output_waveguide)
#--------------------------------------------------------#
##########################################################

sim(contourplot,:ϵᵣ,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ")

################### PREPARE TARGET FIELD #################
### INPUT
########################################################
x_cut = 1.2
sim_wg_in = sim(slice, x̂ , x_cut )
eig_vals , eig_vecs = sim_wg_in(solve_for_modes)
mode_te_in = sim_wg_in(Photon.extractreshape, eig_vecs[:,1] ,x̂)
#mode_tm_in = sim_wg(Photon.extractreshape, eig_vecs[:,2] ,ŷ)
sim_wg_in(lineplot,mode_te_in,real )
input_mode_sim = deepcopy(sim)
input_mode_sim(setbackground!,SiO2)
input_mode_sim(setmaterial!,Si,Cuboid(((0 , .5(Ly - h_wg_in)),(Lx , .5(Ly + h_wg_in)))))
input_mode_sim(contourplot,:ϵᵣ,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ")
input_mode_sim(attachmode!,mode_te_in, input_mode_sim(:J,ẑ), x̂ , x_cut )
input_mode_sim(contourplot,:J,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Jz")
input_mode_sim(solve!)
input_mode_sim(contourplot,  :S, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Sx")
## OUTPUT
##########################################################
y_cut = 1.9
sim_wg_out = sim(slice, ŷ , y_cut )
eig_vals , eig_vecs = sim_wg_out(solve_for_modes)
mode_te_out = sim_wg_out(Photon.extractreshape, eig_vecs[:,1] ,x̂)
sim_wg_out(lineplot,mode_te_out,real )
output_mode_sim = deepcopy(sim)
output_mode_sim(setbackground!,SiO2)
output_mode_sim(setmaterial!,Si, Cuboid(((.5(Lx - w_wg_out),0),(.5(Lx + w_wg_out),Ly))))
output_mode_sim(contourplot,:ϵᵣ,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ")
output_mode_sim(attachmode!,mode_te_out, output_mode_sim(:J,ẑ), ŷ , Ly-y_cut )
output_mode_sim(contourplot,:J,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Jz")
output_mode_sim(solve!)
output_mode_sim(contourplot,  :S, ŷ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Sy")

#########################################################

target_x = zeros(ComplexF64,size(sim.grid))
target_y = zeros(ComplexF64,size(sim.grid))
target_z = zeros(ComplexF64,size(sim.grid))

sim(add!,target_z ,input_mode_sim(:E,ẑ),  x-> .4Lx > x[1] > x_cut)
sim(add!,target_z ,output_mode_sim(:E,ẑ), x-> 0 < x[2] <= 2.3)
sim(contourplot,target_z, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ")

###########################################################
sim(add!,sim(:J,ẑ) ,input_mode_sim(:E,ẑ), EVERYWHERE)
#sim(attachmode!,mode_te_in, sim(:J,ẑ), x̂ , x_cut )
sim(contourplot,  :J, ẑ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Sy")
sim(setTFSF!,x̂,LOW,x_cut + dx)
#sim.ϵᵣ_zz = input_mode_sim.ϵᵣ_zz
#sim(contourplot,  :ϵᵣ, ẑ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Sy")
sim(solve!)
sim(contourplot,  :S, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Sy")
#############################################################
#############################################################
#############################################################

import Photon: GridType , p̂

#######################################
obj =TargetObjective(target_x,target_y,target_z)
optimizer = ADADelta(1)
using ImageFiltering
###########################################
using Gaston
for i in 1:100
f , ∇f  =    f_∇f(obj,sim)
println(f)
sim(update!,optimizer, sim(:ϵᵣ,ẑ), imfilter(∇f[ẑ], Kernel.gaussian(2.5)),design_region)
sim(boxconstraint!,sim(:ϵᵣ,ẑ),(1.45^2,3.64^2),design_region)
sim(gradualbinarize!,sim(:ϵᵣ,ẑ),(1.45^2,3.64^2),0.5*i * (-1.45^2 + 3.64^2)/100,design_region)

heatmap(range(sim.grid,x̂),range(sim.grid,ŷ),real.(sim(:ϵᵣ,ẑ)),Axes(
    title = "'ϵᵣ'", 
    palette = :tempo,
    auto="fix",
    size="ratio -1",
    ))

save(term = "png", output = "./device.png",
saveopts = "font 'Consolas,10' size 1280,900 lw 1 background 'white'")  
    
heatmap(range(sim.grid,x̂),range(sim.grid,ŷ),real.(sim(:E,ẑ)),Axes(
    title = "'Ez'", 
    palette = :balance,
    auto="fix",
    size="ratio -1",
    ))

save(term = "png", output = "./field.png",
saveopts = "font 'Consolas,10' size 1280,900 lw 1 background 'white'")  


end

sim(contourplot,  :E, ẑ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Sy")
sim(contourplot,  :ϵᵣ, ẑ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Sy")





