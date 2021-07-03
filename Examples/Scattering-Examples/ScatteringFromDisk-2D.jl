using  Photon
λ = 1.55;
Lx = 8 * λ; 
Ly = 8 * λ;

sim = Simulation(λ₀ = λ ;  grid = Grid(extent = (Lx,Ly) , spacing =  (λ/15,λ/15) ))
sim(setpml!,λ)
sim(setsrc!, PlaneWave(k̂ = (0,2pi/λ), ê = (0,0,1)))
sim(setTFSF! ,1.1λ)


Si = Material(ϵᵣ = 2.0 )
Rect(x) =  abs(x[2]-Ly/2) <=  λ/2 
sim(setmaterial!,Si,Rect);
sim(contourplot, :ϵᵣ,ẑ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")


sim(solve!)

sim(contourplot, :E ,ẑ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")

objective_function_region(x) =   abs(x[2]-6.75λ)  <=  4*sim.grid.spacing[2]  &&
 abs(x[1]-Lx/2)  <=  4*sim.grid.spacing[1]

function objective_function(sim) 
    sum(map(x-> abs.(x)^2 , sim(:E,x̂,objective_function_region))) + 
	sum(map(x-> abs.(x)^2 , sim(:E,ŷ,objective_function_region))) + 
	sum(map(x-> abs.(x)^2 , sim(:E,ẑ,objective_function_region)))
end

∂L∂ϵᵣ_xx , ∂L∂ϵᵣ_yy , ∂L∂ϵᵣ_zz = sim(∂L∂ϵᵣ,objective_function)

sim(contourplot, ∂L∂ϵᵣ_zz  ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")


for i in 1:100
	∂L∂ϵᵣ_xx , ∂L∂ϵᵣ_yy , ∂L∂ϵᵣ_zz = sim(∂L∂ϵᵣ,objective_function)

	α = 0.1 * abs(inv(maximum(∂L∂ϵᵣ_zz)	))

	sim(add!,sim.ϵᵣ_xx,α * ∂L∂ϵᵣ_zz,Rect)
	sim(add!,sim.ϵᵣ_yy,α * ∂L∂ϵᵣ_zz,Rect)
	sim(add!,sim.ϵᵣ_zz,α * ∂L∂ϵᵣ_zz,Rect)

    println(objective_function(sim))

end

maximum(∂L∂ϵᵣ_zz)

sim(contourplot, :ϵᵣ ,ẑ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
sim(contourplot, :E ,ẑ , real ; xlabel = "x-axis", ylabel = "y-axis", title = "Ez")
