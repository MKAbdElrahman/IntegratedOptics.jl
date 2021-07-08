function (sim::Simulation)(::typeof(get), sym::Symbol, dir::Direction{D}; reshaped::Bool = true)  where D
	F = getproperty(sim,sym)
	Nw = ncells(sim.grid);	
	F_vec = F[((D-1)*Nw +1) : (D*Nw)]
	reshaped ? reshape(F_vec,size(sim.grid)) : F_vec
end

function (sim::Simulation{Dim})(sym::Symbol,dir::Direction{D})  where {Dim,D}

    !(sym === :ϵᵣ && x̂ == dir ) || return sim.ϵᵣ_xx
	!(sym === :ϵᵣ && ŷ == dir ) || return sim.ϵᵣ_yy
	!(sym === :ϵᵣ && ẑ == dir ) || return sim.ϵᵣ_zz

	!(sym === :μᵣ && x̂ == dir ) || return sim.μᵣ_xx
	!(sym === :μᵣ && ŷ == dir ) || return sim.μᵣ_yy
	!(sym === :μᵣ && ẑ == dir ) || return sim.μᵣ_zz

	!(sym === :J && x̂ == dir ) || return sim.J_x
	!(sym === :J && ŷ == dir ) || return sim.J_y
	!(sym === :J && ẑ == dir ) || return sim.J_z

	!(sym === :PML && x̂ == dir ) || return sim.S_x
	!(sym === :PML && ŷ == dir ) || return sim.S_y
	!(sym === :PML && ẑ == dir ) || return sim.S_z


	!(sym === :Q && x̂ == dir ) || return sim.Q
	!(sym === :Q && ŷ == dir ) || return sim.Q
	!(sym === :Q && ẑ == dir ) || return sim.Q

	# Electric Field
	!(sym === :E && x̂ == dir ) || return sim(get,:E,x̂)
	!(sym === :E && ŷ == dir ) || return sim(get,:E,ŷ)
	!(sym === :E && ẑ == dir ) || return sim(get,:E,ẑ)
	
	# Magnetic Field
	!(sym === :H && x̂ == dir ) || return  -1 / (im*2pi/sim.λ₀ ) .* (∂(p̂,sim.grid,ŷ,sim(:E,ẑ)) - ∂(p̂,sim.grid,ẑ,sim(:E,ŷ))) 
	!(sym === :H && ŷ == dir ) || return   1 / (im*2pi/sim.λ₀ ) .* (∂(p̂,sim.grid,x̂,sim(:E,ẑ)) - ∂(p̂,sim.grid,ẑ,sim(:E,x̂))) 
	!(sym === :H && ẑ == dir ) || return  -1 / (im*2pi/sim.λ₀ ) .* (∂(p̂,sim.grid,x̂,sim(:E,ŷ)) - ∂(p̂,sim.grid,ŷ,sim(:E,x̂))) 

	# Complex Poynting Vector
	!(sym === :S && x̂ == dir ) || return  sim(:E,ŷ)  .* conj.(sim(:H,ẑ)) - sim(:E,ẑ) .* conj.(sim(:H,ŷ))
	!(sym === :S && ŷ == dir ) || return -(sim(:E,x̂) .* conj.(sim(:H,ẑ)) - sim(:E,ẑ) .* conj.(sim(:H,x̂)))
	!(sym === :S && ẑ == dir ) || return  sim(:E,x̂)  .* conj.(sim(:H,ŷ)) - sim(:E,ŷ) .* conj.(sim(:H,x̂))
end
