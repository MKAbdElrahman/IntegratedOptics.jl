using Base: pause
using Photon
using LinearAlgebra: dot , norm

λ = 1.0;

Lx = 10.0 ; 
Ly = 8.0;

sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (0.07,0.07) ))

Si = Material(ϵᵣ = 4 )


input_wg(x) =  abs(x[2] - Ly/2) <= 0.5

sim(setmaterial!,Si,input_wg)

sim(contourplot,:ϵᵣ,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")

sim(setpml!,λ)

sim_wg = sim(slice,x̂ , (1,Ly/2) )


sim_wg(lineplot,:ϵᵣ,x̂,real)

eig_vals , eig_vecs = sim_wg(solve_for_modes)

mode_te_in = sim_wg(Photon.extractreshape, eig_vecs[:,1] ,x̂)
#mode_tm_in = sim_wg(Photon.extractreshape, eig_vecs[:,2] ,ŷ)

sim_wg(lineplot,mode_te_in,real )

sim(attachmode!,mode_te_in, sim.J_z, x̂ ,  (1,Ly/2) )

sim(contourplot,:J,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")

sim(solve!)

sim(contourplot,  :S, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")

 sim.J_z  = sim(:E,ẑ)

sim(setTFSF!,x̂ ,1)

sim(solve!)

sim(contourplot,  :S, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")



target_x = zeros(ComplexF64,size(sim.grid))
target_y = zeros(ComplexF64,size(sim.grid))
target_z = zeros(ComplexF64,size(sim.grid))

sim(add!,target_z ,sim(:E,ẑ), x-> x[1] < Lx/2-2)

sim(contourplot,target_z, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")

INP = sum(real.(sim(:S,x̂, x -> abs(x[1] -1.5 ) <= .15  && abs(x[2]-.5Ly) <= .75)))


#####################################
#####################################

sim.activate_tfsf = false

Air = Material(ϵᵣ = 1.0 )
sim(setmaterial!,Air,x->true)

out_wg(x) =  abs(x[2] - Ly/2 + 1.5 ) <= .5 

sim(setmaterial!,Si,out_wg)

sim(contourplot,:ϵᵣ,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")

sim_wg = sim(slice,x̂ , (1,Ly/2) )

sim_wg(lineplot,:ϵᵣ,x̂,real)

eig_vals , eig_vecs = sim_wg(solve_for_modes)

mode_te = sim_wg(Photon.extractreshape, eig_vecs[:,1] ,x̂)
mode_tm = sim_wg(Photon.extractreshape, eig_vecs[:,2] ,ŷ)

sim_wg(lineplot,mode_te,real )

sim.J_z = 0 .* sim.J_z # reset source
sim(attachmode!,mode_te, sim.J_z, x̂ ,  (1,Ly/2) )
sim(contourplot,:J,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
sim(solve!)

sim(contourplot,  :S, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")

 sim.J_z  = sim(:E,ẑ)

sim(setTFSF!,x̂ ,1)

sim(solve!)

sim(contourplot,  :S, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")

sim(add!,target_z ,sim(:E,ẑ), x-> x[1] > Lx/2+2)

sim(contourplot,target_z, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
###############################################################
###############################################################
##############################################################

sim.activate_tfsf = false

Air = Material(ϵᵣ = 1.0 )
sim(setmaterial!,Air,x->true)

out_wg(x) = abs(x[2] - Ly/2 - 1.5 ) <= .5

sim(setmaterial!,Si,out_wg)

sim(contourplot,:ϵᵣ,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")

sim_wg = sim(slice,x̂ , (1,Ly/2) )

sim_wg(lineplot,:ϵᵣ,x̂,real)

eig_vals , eig_vecs = sim_wg(solve_for_modes)

mode_te = sim_wg(Photon.extractreshape, eig_vecs[:,1] ,x̂)
mode_tm = sim_wg(Photon.extractreshape, eig_vecs[:,2] ,ŷ)

sim_wg(lineplot,mode_te,real )

sim.J_z = 0 .* sim.J_z # reset source
sim(attachmode!,mode_te, sim.J_z, x̂ ,  (1,Ly/2) )
sim(contourplot,:J,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
sim(solve!)

sim(contourplot,  :S, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")

 sim.J_z  = sim(:E,ẑ)

sim(setTFSF!,x̂ ,1)

sim(solve!)

sim(contourplot,  :S, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")

sim(add!,target_z ,sim(:E,ẑ), x-> x[1] > Lx/2+2)

sim(contourplot,target_z, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")

##############################################################
##############################################################
const EVERYWHERE = x -> true
sim(setmaterial!,Air,EVERYWHERE)
out_wg(x) = (x[1] > .5*Lx) && ( abs(x[2] - Ly/2 + 1.5 ) <= .5 || abs(x[2] - Ly/2 - 1.5 ) <= .5)
sim(setmaterial!,Si,out_wg)
input_wg(x) = (x[1] <= .5*Lx) && (abs(x[2] - Ly/2 ) <= 0.5)
sim(setmaterial!,Si,input_wg)
sim(contourplot,  :ϵᵣ, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")

sim.J_z = 0 .* sim.J_z
sim(attachmode!,mode_te_in, sim.J_z, x̂ ,  (1,Ly/2) )

##############################################################

target = (target_x,target_y,target_z)
##############################################################
function objective_function(sim,target) 
    ex,ey,ez =   sim(:E,x̂) , sim(:E,ŷ) ,   sim(:E,ẑ)
    e = [ex[:] ; ey[:]; ez[:]]
    tx,ty,tz =   target
    t = [tx[:] ; ty[:]; tz[:]]
    real(dot(e,t) / dot(t,t))
    end
    
    println("Objective Function: ",objective_function(sim,target))
        
    ################ Design Region ###########
    in_r1(x) = 3.5<= x[1] <= 6.5  &&  abs(x[2]- Ly/2) <= .5  
    in_r2(x) = 6<= x[1] <= 6.5  &&  abs(x[2]- Ly/2-1) <= .5  
    in_r3(x) = 6<= x[1] <= 6.5  &&  abs(x[2]- Ly/2+1) <= .5  

    Design_Region(x) =  3.5<= x[1] <=6.5  &&  abs(x[2]- Ly/2) <= 2.1#  && !(in_r1(x) ) && !(in_r2(x) ) && !(in_r3(x) )
    sim(setmaterial!, Material(ϵᵣ = 3.5 ),Design_Region)
    ##########################################
    
    ################ Learning Rate Function ###########
    function Calculate_α(oldRelativePermitivity,objFuncGrad,∇ϵr_max = 0.1,γ = -0)
        max_dJdϵ = findmax(real.(objFuncGrad))[1]
        max_oldRelativePermitivity = findmax(real.(oldRelativePermitivity))[1]
        α = 1/max_dJdϵ * (∇ϵr_max - γ * max_oldRelativePermitivity)
        return α
    end
    ###########################################
    
    data = Float64[]
    out_1_data = Float64[]
    out_2_data = Float64[]
    data_in_p = Float64[]
    using Gaston
    function track()
    x = range(sim.grid,x̂)
    y = range(sim.grid,ŷ)
    @gp "set multiplot layout 2,2"
    @gp :- 1 data "w l notit"  "set auto fix" "set size square" "set size ratio 1"	
    @gp :- 2 x y real.(sim(:ϵᵣ,ẑ)) "w image notit" "set auto fix" "set size square"
    @gp :- xlab = "x" ylab = "y" "set cblabel 'z'" palette(:dense,smooth = true)
    @gp :- title = "device"
    @gp :- xlab = "x" ylab = "y" "set size ratio -1"	
    @gp :- 3 x y real.(sim(:E,ẑ)) "w image notit" "set auto fix" 
    @gp :- xlab = "x" ylab = "y" "set cblabel 'z'" palette(:dense)
    @gp :- title = "device"
    @gp :- xlab = "x" ylab = "y" "set size ratio -1"	"set size square"
    @gp :- 4  out_1_data  "w l notit"  "set auto fix" "set size square" "set size ratio 1"
   @gp :-  out_2_data  "w l notit"  "set auto fix" "set size square" "set size ratio 1"
 #   @gp :-  data_in_p  "w l notit"  "set auto fix" "set size square" "set size ratio 1"
    Gnuplot.save(term="pngcairo", output="./plots/output.png")
    end

    for t in 1:10000
        ########### Sensitivty #######
         ∂L∂ϵᵣ_xx , ∂L∂ϵᵣ_yy , ∂L∂ϵᵣ_zz = sim(∂L∂ϵᵣ2,target)
        ### Gradient Descent###
        α =  2*Calculate_α(sim.ϵᵣ_zz,∂L∂ϵᵣ_zz)
         sim(add!,sim.ϵᵣ_zz,α * ∂L∂ϵᵣ_zz,Design_Region)
        ########## Constraints ########
        for i in eachindex(sim.ϵᵣ_zz)
            if real.(sim.ϵᵣ_zz[i])  >  4.0  sim.ϵᵣ_zz[i] = 4.0 end
            if real.(sim.ϵᵣ_zz[i]) <   1.0  sim.ϵᵣ_zz[i] = 1.0 end
        if t > 100
            if abs(4 - real(sim.ϵᵣ_zz[i])) <=  t/400   sim.ϵᵣ_zz[i] = 4.0   end
            if abs(real(sim.ϵᵣ_zz[i]) - 1) <=  t/400  sim.ϵᵣ_zz[i] = 1.0   end
        end


        end
        sim.ϵᵣ_xx = sim.ϵᵣ_zz
        sim.ϵᵣ_yy = sim.ϵᵣ_zz
        ################################
        obj_value = objective_function(sim,target)
        println("$(t): Objective Function: ", obj_value)
        push!(data,obj_value)

in_p = sum(real.(sim(:S,x̂, x -> abs(x[1] -1.5 ) <= .15  && abs(x[2]-.5Ly) <= .75))) 
out_1_p = sum(real.(sim(:S,x̂, x -> abs(x[1] -8) <= .15  && abs(x[2]-.5Ly + 1 ) <= .75))) / in_p
out_2_p = sum(real.(sim(:S,x̂, x -> abs(x[1] -8) <= .15  && abs(x[2]-.5Ly - 1 ) <= .75))) / in_p

push!(data_in_p,in_p)
push!(out_1_data,out_1_p)
push!(out_2_data,out_2_p)


       #display(plot(data, w  = :lp,     lw = 3))
       #sleep(.5)
       #display(imagesc(real.(sim.E_z')))
       #sleep(.5)
       #display(imagesc(real.(sim.ϵᵣ_zz')))
      if mod(t,2) == 0  track() end 
    end
    
    sim(contourplot,:E,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
    sim(contourplot,:ϵᵣ,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
    
    

irange = round(Int,3.5/spacing(sim.grid,1)):round(Int,6.5/spacing(sim.grid,1))
jrange = round(Int,2.25/spacing(sim.grid,2)):round(Int,5.75/spacing(sim.grid,1))



using Gnuplot



track()


sim(:S,x̂)

sim(contourplot,:S,x̂, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")





in_p = sum(real.(sim(:S,x̂, x -> abs(x[1] -1.5 ) <= .15  && abs(x[2]-.5Ly) <= .75))) 

out_1_p = sum(real.(sim(:S,x̂, x -> abs(x[1] -8) <= .15  && abs(x[2]-.5Ly + 1 ) <= .75))) / in_p
out_2_p = sum(real.(sim(:S,x̂, x -> abs(x[1] -8) <= .15  && abs(x[2]-.5Ly - 1 ) <= .75))) / in_p

(out_1_p) / in_p
(out_2_p) / in_p




