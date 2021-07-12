using IntegratedOptics
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
dx , dy = (λ₀/10/n_max) .* (1, 1)
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
input_waveguide  = Cuboid(((0 , .5(Ly - h_wg_in)),(.4(Lx) , .5(Ly + h_wg_in))))
sim(setmaterial!,Si,input_waveguide)
#--------------------------------------------------------#
h_wg_out_1 = 0.5
output_waveguide_1  = Cuboid(((.6Lx , .5(Ly - h_wg_out_1)),(Lx , .5(Ly + h_wg_out_1))))
sim(setmaterial!,Si,output_waveguide_1)
#--------------------------------------------------------#
#--------------------------------------------------------#
w_wg_out_2 = 0.5
output_waveguide_2  = Cuboid(((.5(Lx - w_wg_out_2),0),(.5(Lx + w_wg_out_2),.4Ly)))
sim(setmaterial!,Si,output_waveguide_2)
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
mode_te_in = sim_wg_in(extractreshape, eig_vecs[:,1] ,x̂)
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

### OUTPUT1
########################################################
x_cut = 1.2
sim_wg_out_1 = sim(slice, x̂ , x_cut )
eig_vals , eig_vecs = sim_wg_out_1(solve_for_modes,solver = EigArpack())
mode_te_out_1 = sim_wg_out_1(extractreshape, eig_vecs[:,1] ,x̂)
#mode_tm_in = sim_wg(Photon.extractreshape, eig_vecs[:,2] ,ŷ)
sim_wg_out_1(LinePlot,mode_te_out_1,lw = 2,title = "'mode profile'")
output_1_mode_sim = deepcopy(sim)
output_1_mode_sim(setbackground!,SiO2)
output_1_mode_sim(setmaterial!,Si,Cuboid(((0 , .5(Ly - h_wg_out_1)),(Lx , .5(Ly + h_wg_out_1)))))
output_1_mode_sim(HeatMap,:ϵᵣ,ẑ, axes = ϵ_axes)
output_1_mode_sim(attachmode!,mode_te_out_1, output_1_mode_sim(:J,ẑ), x̂ , x_cut )
output_1_mode_sim(HeatMap,:J,ẑ)
output_1_mode_sim(solve!)
output_1_mode_sim(HeatMap,:E,ẑ, axes = Ez_axes)

## OUTPUT 2 
##########################################################
y_cut = 1.9
sim_wg_out_2 = sim(slice, ŷ , y_cut )
eig_vals , eig_vecs = sim_wg_out_2(solve_for_modes)
mode_te_out_2 = sim_wg_out_2(extractreshape, eig_vecs[:,3] ,x̂)
sim_wg_out_2(LinePlot,mode_te_out_2,lw = 2,title = "'mode profile'")
output_2_mode_sim = deepcopy(sim)
output_2_mode_sim(setbackground!,SiO2)
output_2_mode_sim(setmaterial!,Si, Cuboid(((.5(Lx - w_wg_out_2),0),(.5(Lx + w_wg_out_2),Ly))))
output_2_mode_sim(HeatMap,:ϵᵣ,ẑ,axes =ϵ_axes)
output_2_mode_sim(attachmode!,mode_te_out_2, output_2_mode_sim(:J,ẑ), ŷ , Ly-y_cut )
output_2_mode_sim(HeatMap,:J,ẑ)
output_2_mode_sim(solve!)
output_2_mode_sim(HeatMap,:E,ẑ,axes = Ez_axes)
#########################################################
import LinearAlgebra: normalize
target_x = zeros(ComplexF64,size(sim.grid))
target_y = zeros(ComplexF64,size(sim.grid))
target_z = zeros(ComplexF64,size(sim.grid))

in_p = 1 / sqrt(abs(real.(input_mode_sim(:S,x̂,((x̂,2,2),(ŷ,3,3))))[1]))
input_mode_sim.E .*= in_p

out_1_p = 1 / sqrt(abs(real.(output_1_mode_sim(:S,x̂,((x̂,4.5,4.5),(ŷ,3,3))))[1]))
output_1_mode_sim.E .*= out_1_p


out_2_p = 1 / sqrt(abs(real.(output_2_mode_sim(:S,ŷ,((x̂,3,3),(ŷ,2,2))))[1]))
output_2_mode_sim.E .*= out_2_p



sim(add!,target_z , input_mode_sim(:E,ẑ),  x-> .4Lx > x[1] > x_cut)
sim(add!,target_z , (1/sqrt(4)) *  output_2_mode_sim(:E,ẑ), x-> 0 <= x[2] <= 2.3)
sim(add!,target_z , (sqrt(3)/sqrt(4)) *  output_1_mode_sim(:E,ẑ), x-> Lx-2.3 <= x[1] <= Lx)

sim(HeatMap,target_z, axes = Ez_axes)

###########################################################
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
optimizer = Descent(1.0)
using ImageFiltering
using LocalFilters
kernel = Kernel.gaussian(2)
ϵ_limits = (1.45^2,3.64^2)
Nt = 100
binarization_rate(i) =  0.5* i * -(-(ϵ_limits...))/Nt
###########################################
# Optimization Loop
for i in 1:Nt
    f , ∇f  =  f_∇f(obj,sim,solver = LU())
    sim(update!,optimizer, sim(:ϵᵣ,ẑ), localmean(∇f[ẑ], 3),design_region)
    sim(update!,optimizer, sim(:ϵᵣ,ẑ), closing(∇f[ẑ], 5),design_region)

# if mod(i,10)==0   sim(set!, sim(:ϵᵣ,ẑ),localmean( sim(:ϵᵣ,ẑ),2),design_region) end
    sim(boxconstraint!,sim(:ϵᵣ,ẑ),ϵ_limits,design_region)
    sim(gradualbinarize!,sim(:ϵᵣ,ẑ),ϵ_limits,binarization_rate(i),design_region)
   #### 
  #  sim(saveplot,term = "./plots/eps/eps_$(i).png")
    trans_2 = real.(sim(:S,ŷ,((x̂,3,3),(ŷ,2,2)))) 
    trans_1 = real.(sim(:S,x̂,((x̂,4.5,4.5),(ŷ,3,3))))  
 
    println("iter:$(i)",": ",trans_1, " , ",trans_2 )
   # display(sim(HeatMap,  :ϵᵣ, ẑ,axes =ϵ_axes ))
  #  sim(saveplot,output = "./plots/devices/ninety_bend/eps/eps_$(i).png")
 #   display(sim(HeatMap,  :E, ẑ,axes =Ez_axes )) 
#    sim(saveplot,output = "./plots/devices/ninety_bend/Ez/Ez_$(i).png")
       ####
end

