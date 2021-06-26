export  setpml!

function  setpml! end


_s(d::Real,L::Real,lam ; m::Real=1,s_min::Real = 3.0) = -im * s_min * (d^m*lam)/L^(m+1)
s(::High,x,d,l,lam)::Complex{Float} = (_s(x-(l - d),d,lam))
s(::Low,x,d,l,lam)::Complex{Float}  = (_s((-x + d) , d, lam))
	
	
function get_S_comp(sim::Simulation{Dim},  dir::Direction{D}) where {D,Dim}
		   if D == 1 return sim.S_x end
		   if D == 2 return sim.S_y end
	       if D == 3 return sim.S_z end
end
	
function (sim::Simulation)(::typeof(setpml!),dir::Direction{D},side::Low, thickness::Number,gridtype::GridType= p̂) where {D}
 S = get_S_comp(sim,dir)			
 sim(add!,S,x -> s(side,x[D],thickness, extent(sim.grid,dir),sim.λ₀) ,x -> x[D] <= thickness, gridtype)		
end

	
function (sim::Simulation)(::typeof(setpml!),dir::Direction{D},side::High, thickness::Number,gridtype::GridType= p̂) where {D}	
S = get_S_comp(sim,dir)	
 sim(add!,S,x -> s(side,x[D],thickness, extent(sim.grid,dir),sim.λ₀) ,x -> x[D] >= extent(sim.grid,dir) - thickness, gridtype)		
end
	
function (sim::Simulation)(::typeof(setpml!),dir::Direction{D}, thickness::Number,gridtype::GridType= p̂) where {D}	
 (sim::Simulation)(setpml!,dir,HIGH, thickness,gridtype)
 (sim::Simulation)(setpml!,dir,LOW, thickness,gridtype)				
end
	
function (sim::Simulation{1})(::typeof(setpml!), thickness::Number,gridtype::GridType= p̂) 
sim(setpml!,x̂, thickness,gridtype)	
end
function (sim::Simulation{2})(::typeof(setpml!), thickness::Number,gridtype::GridType= p̂) 
sim(setpml!,x̂, thickness,gridtype)	
sim(setpml!,ŷ, thickness,gridtype)			
end	
function (sim::Simulation{3})(::typeof(setpml!), thickness::Number,gridtype::GridType= p̂) 	
sim(setpml!,x̂, thickness,gridtype)	
sim(setpml!,ŷ, thickness,gridtype)	
sim(setpml!,ẑ, thickness,gridtype)				
end	