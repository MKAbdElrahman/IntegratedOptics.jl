   
using Photon
import Photon: ExtractReshape

λ = 1.55;

Lx = 6 * λ; 
Ly = 6 * λ;

sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (λ/20,λ/20) ))

sim(setpml!,λ)


sim(setsrc!, PlaneWave(k̂ = (0,2pi/λ), ê = (0,0,1)))
#sim(contourplot,:J,ẑ, real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")


sim(setTFSF! ,1.5λ)


Silver = Material(ϵᵣ = 4 )

Disk(x) = sqrt((x[1]-Lx/2)^2 + (x[2]-Ly/2)^2)  <=  1.2 

sim(setmaterial!,Silver,Disk)

#sim(contourplot,  :ϵᵣ, x̂ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵ x")

 sim(init!)
 sim(solve!)
 using SparseArrays
 
δϵᵣ = zeros(ComplexF64,3*ncells(sim.grid))   
import LinearAlgebra: norm



function  objective_function(sim) 
    norm(sim(:E,ẑ , Disk))
end


for i in 1:100
println(i, ": objective_function: ",objective_function(sim)  )
sim(sensitivity!,objective_function)
δϵᵣ  .= 0.1 * (2pi/sim.λ₀)^2 * (sim.sensitivity)/norm(sim.sensitivity)

sim(add!,sim(:ϵᵣ,x̂),sim(ExtractReshape(),δϵᵣ ,x̂),Disk)
sim(add!,sim(:ϵᵣ,ŷ),sim(ExtractReshape(),δϵᵣ ,ŷ),Disk)
sim(add!,sim(:ϵᵣ,ẑ),sim(ExtractReshape(),δϵᵣ ,ẑ),Disk)

sim.sysetm_matrix .+= spdiagm(0=>  δϵᵣ )
sim(solve!)
end

display(sim(contourplot,:E,ẑ, abs ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez"))
