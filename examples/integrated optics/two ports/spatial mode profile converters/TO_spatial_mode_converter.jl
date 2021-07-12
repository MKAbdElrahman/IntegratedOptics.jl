##########################################################
###################### BUILD DEVICE ######################
using Photon
######################
# Plot Options
ϵ_axes = Axes(title = "'ϵᵣ'",xlabel = "'x'", ylabel = "'y'", palette = :tempo, auto = "fix",size =" ratio -1")
Ez_axes = Axes(title = "'Ez'",xlabel = "'x'", ylabel = "'y'", palette = :balance, auto = "fix",size =" ratio -1")
######################
######################## MATERIALS ########################
Si =   Material(ϵᵣ = 3.64^2 )
SiO2 = Material(ϵᵣ = 1.45^2 )
Fg = Material(ϵᵣ = .8*(1.45^2 + 3.46^2) )
##########################################################
######################## SIMULATION #######################
λ₀ = 1.55
Lx , Ly =  λ₀ .* (4 , 3)
n_max = 3.64 
n_min = 1.45 
dx , dy = (λ₀/18/n_max) .* (1, 1)
sim = Simulation(λ₀ = 1.55 ;  grid = Grid(extent = (Lx,Ly) , spacing =  (dx,dy) ))
sim(setpml!,1.0)
##########################################################
###################### BUILD DEVICE ######################
#--------------------------------------------------------#
sim(setbackground!,SiO2)
#--------------------------------------------------------#
w_d = 1.2
h_d = 1.5
design_region = Cuboid(((.5(Lx - w_d) , .5(Ly - h_d)),(.5(Lx + w_d) , .5(Ly + h_d))))
sim(setmaterial!,Fg, design_region)
#--------------------------------------------------------#
h_wg_in = 0.5
input_waveguide  = Cuboid(((0 , .5(Ly - h_wg_in)),(.45(Lx) , .5(Ly + h_wg_in))))
sim(setmaterial!,Si,input_waveguide)
#--------------------------------------------------------#
h_wg_out = 0.5
output_waveguide  =  Cuboid(((.55Lx , .5(Ly - h_wg_out)),(Lx , .5(Ly + h_wg_out))))
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
###########################################
## OUTPUT
##########################################################
x_cut = 1.2
sim_wg_out = sim(slice, x̂ , x_cut )
eig_vals , eig_vecs = sim_wg_out(solve_for_modes)
mode_te_out = sim_wg_out(Photon.extractreshape, eig_vecs[:,3] ,x̂)
sim_wg_out(LinePlot,mode_te_out,lw = 2,title = "'mode profile'")
output_mode_sim = deepcopy(sim)
output_mode_sim(setbackground!,SiO2)
output_mode_sim(setmaterial!,Si,Cuboid(((0 , .5(Ly - h_wg_in)),(Lx , .5(Ly + h_wg_in)))))
output_mode_sim(HeatMap,:ϵᵣ,ẑ,axes =ϵ_axes)
output_mode_sim(attachmode!,mode_te_out, output_mode_sim(:J,ẑ), x̂ , x_cut )
output_mode_sim(HeatMap,:J,ẑ)
output_mode_sim(solve!)
output_mode_sim(HeatMap,:E,ẑ,axes = Ez_axes)
#########################################################



target_x = zeros(ComplexF64,size(sim.grid))
target_y = zeros(ComplexF64,size(sim.grid))
target_z = zeros(ComplexF64,size(sim.grid))

sim(add!,target_z ,input_mode_sim(:E,ẑ),  x-> .4Lx > x[1] > x_cut)
sim(add!,target_z ,output_mode_sim(:E,ẑ), x-> .6Lx < x[1] <= Lx-x_cut)
sim(HeatMap,target_z, axes = Ez_axes)

sim(add!,sim(:J,ẑ) ,input_mode_sim(:E,ẑ), EVERYWHERE)
#sim(attachmode!,mode_te_in, sim(:J,ẑ), x̂ , x_cut )
#sim(HeatMap,  :J, ẑ)
sim(setTFSF!,x̂,LOW,x_cut + dx)
#sim.ϵᵣ_zz = input_mode_sim.ϵᵣ_zz
sim(solve!)
#############################################################
# Toplogy Optimization 
#######################################
# Optimization Settings
obj =TargetObjective(target_x,target_y,target_z)
optimizer = ADAGrad(1)
using ImageFiltering
kernel = Kernel.gaussian(3)
ϵ_limits = (1.45^2,3.64^2)
Nt = 100
binarization_rate(i) =  0.5* i * -(-(ϵ_limits...))/Nt
###########################################
# Optimization Loop
for i in 1:Nt
    f , ∇f  =  f_∇f(obj,sim,solver = LU())
    sim(update!,optimizer, sim(:ϵᵣ,ẑ), imfilter(∇f[ẑ], kernel),design_region)

    sim(boxconstraint!,sim(:ϵᵣ,ẑ),ϵ_limits,design_region)
    sim(gradualbinarize!,sim(:ϵᵣ,ẑ),ϵ_limits,binarization_rate(i),design_region)
   #### 
    iseven(i) ? display(sim(HeatMap,  :E, ẑ,axes =Ez_axes )) : display(sim(HeatMap,  :ϵᵣ, ẑ,axes =ϵ_axes ))
    trans = sum(real.(sim(:S,x̂,((x̂,4.5,4.5),(ŷ,1.5,3))))) / sum(real.(sim(:S,x̂,((x̂,2,2),(ŷ,1.5,3))))) 
    println("iter:$(i)",": ",trans)
   ####
end

