using Photon

######################
# Plot Options
ϵ_axes = Axes(title = "'ϵᵣ'",xlabel = "'x'", ylabel = "'y'", palette = :tempo, auto = "fix",size =" ratio -1")
Ez_axes = Axes(title = "'Ez'",xlabel = "'x'", ylabel = "'y'", palette = :balance, auto = "fix",size =" ratio -1")
######################
######################## MATERIALS ########################
Si =   Material(ϵᵣ = 3.64^2 )
SiO2 = Material(ϵᵣ = 1.45^2 )
Fg = Material(ϵᵣ = .5*(1.45^2 + 3.46^2) )
##########################################################
######################## SIMULATION #######################
λ₀ = 1.55
Lx , Ly =  λ₀ .* (4 , 4)
n_max = 3.64 
n_min = 1.45 
dx , dy = (λ₀/12/n_max) .* (1, 1)
sim = Simulation(λ₀ = 1.55 ;  grid = Grid(extent = (Lx,Ly) , spacing =  (dx,dy) ))
sim(setpml!,1.0)

##########################################################
###################### BUILD DEVICE ######################
#--------------------------------------------------------#
sim(setbackground!,SiO2)
#--------------------------------------------------------#
w_d = 1.5
h_d = 1.5
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
sim(HeatMap,:ϵᵣ,ẑ, axes = ϵ_axes)
#sim(saveplot , output = "./device.png")
################### PREPARE TARGET FIELD #################
### INPUT
########################################################
x_cut = 1.2
sim_wg_in = sim(slice, x̂ , x_cut )
eig_vals , eig_vecs = sim_wg_in(solve_for_modes,solver = EigArpack())
mode_te_in = sim_wg_in(Photon.extractreshape, eig_vecs[:,1] ,x̂)
#mode_tm_in = sim_wg(Photon.extractreshape, eig_vecs[:,2] ,ŷ)
sim_wg_in(LinePlot,mode_te_in,lw = 2,title = "'mode profile'")
input_mode_sim = deepcopy(sim)
input_mode_sim(setbackground!,SiO2)
input_mode_sim(setmaterial!,Si,Cuboid(((0 , .5(Ly - h_wg_in)),(Lx , .5(Ly + h_wg_in)))))
input_mode_sim(HeatMap,:ϵᵣ,ẑ, axes = ϵ_axes)
input_mode_sim(attachmode!,mode_te_in, input_mode_sim(:J,ẑ), x̂ , x_cut )
input_mode_sim(HeatMap,:J,ẑ)
input_mode_sim(solve!)
input_mode_sim(HeatMap,:E,ẑ, axes = Ez_axes)

## OUTPUT
##########################################################
y_cut = 1.9
sim_wg_out = sim(slice, ŷ , y_cut )
eig_vals , eig_vecs = sim_wg_out(solve_for_modes)
mode_te_out = sim_wg_out(Photon.extractreshape, eig_vecs[:,1] ,x̂)
sim_wg_out(LinePlot,mode_te_out,lw = 2,title = "'mode profile'")
output_mode_sim = deepcopy(sim)
output_mode_sim(setbackground!,SiO2)
output_mode_sim(setmaterial!,Si, Cuboid(((.5(Lx - w_wg_out),0),(.5(Lx + w_wg_out),Ly))))
output_mode_sim(HeatMap,:ϵᵣ,ẑ,axes =ϵ_axes)
output_mode_sim(attachmode!,mode_te_out, output_mode_sim(:J,ẑ), ŷ , Ly-y_cut )
output_mode_sim(HeatMap,:J,ẑ)
output_mode_sim(solve!)
output_mode_sim(HeatMap,:E,ẑ,axes = Ez_axes)
#########################################################

target_x = zeros(ComplexF64,size(sim.grid))
target_y = zeros(ComplexF64,size(sim.grid))
target_z = zeros(ComplexF64,size(sim.grid))

sim(add!,target_z ,input_mode_sim(:E,ẑ),  x-> .4Lx > x[1] > x_cut)
sim(add!,target_z ,output_mode_sim(:E,ẑ), x-> 0 < x[2] <= 2.3)
sim(HeatMap,target_z, axes = Ez_axes)

###########################################################
sim(add!,sim(:J,ẑ) ,input_mode_sim(:E,ẑ), EVERYWHERE)
#sim(attachmode!,mode_te_in, sim(:J,ẑ), x̂ , x_cut )
sim(HeatMap,  :J, ẑ)
sim(setTFSF!,x̂,LOW,x_cut + dx)
#sim.ϵᵣ_zz = input_mode_sim.ϵᵣ_zz
sim(solve!)
#############################################################
# Toplogy Optimization 
#######################################
# optimizer
obj =TargetObjective(target_x,target_y,target_z)
optimizer = ADADelta(1)
##########################################
#Filtering 
using ImageFiltering
kernel = Kernel.gaussian(1.5)
###########################################
#Optimization Loop
for i in 1:100
    f , ∇f  =  f_∇f(obj,sim)
    println("iter:$(i)",":","\t",f)
    sim(update!,optimizer, sim(:ϵᵣ,ẑ), imfilter(∇f[ẑ], kernel),design_region)
    sim(boxconstraint!,sim(:ϵᵣ,ẑ),(1.45^2,3.64^2),design_region)
    sim(gradualbinarize!,sim(:ϵᵣ,ẑ),(1.45^2,3.64^2),0.5*i * (-1.45^2 + 3.64^2)/100,design_region)
    display(sim(HeatMap,  :ϵᵣ, ẑ,axes =ϵ_axes ))
end