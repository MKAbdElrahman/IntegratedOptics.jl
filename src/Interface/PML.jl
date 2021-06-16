export  setpml!
struct PML end
const  setpml! = PML()


_s(d::Real,L::Real;m::Real=3.5,s_min::Real=1.5) = (s_min) *  (d/L + 0.0im)^m	
s(::High,x,d,l)::Complex{Float} = -im*(_s(x - (l - d)  ,  d))
s(::Low,x,d,l)::Complex{Float}  = -im*(_s((-x + d) , d))
	
	
function get_S_comp(sim::Simulation{Dim},  dir::Direction{D}) where {D,Dim}
		   if D == 1 return sim.S_x end
		   if D == 2 return sim.S_y end
	       if D == 3 return sim.S_z end
end
	
function (sim::Simulation)(::PML,dir::Direction{D},side::Low, thickness::Number,gridtype::GridType= p̂) where {D}
 S = get_S_comp(sim,dir)			
 sim(add!,S,x -> s(side,x[D],thickness, extent(sim.grid,dir)) ,x -> x[D] <= thickness, gridtype)		
end

	
function (sim::Simulation)(::PML,dir::Direction{D},side::High, thickness::Number,gridtype::GridType= p̂) where {D}	
S = get_S_comp(sim,dir)	
 sim(add!,S,x -> s(side,x[D],thickness, extent(sim.grid,dir)) ,x -> x[D] >= extent(sim.grid,dir) - thickness, gridtype)		
end
	
function (sim::Simulation)(pml::PML,dir::Direction{D}, thickness::Number,gridtype::GridType= p̂) where {D}	
 (sim::Simulation)(pml,dir,HIGH, thickness,gridtype)
 (sim::Simulation)(pml,dir,LOW, thickness,gridtype)				
end
	
function (sim::Simulation{1})(t::PML, thickness::Number,gridtype::GridType= p̂) 
sim(t,x̂, thickness,gridtype)	
end
function (sim::Simulation{2})(t::PML, thickness::Number,gridtype::GridType= p̂) 
sim(t,x̂, thickness,gridtype)	
sim(t,ŷ, thickness,gridtype)			
end	
function (sim::Simulation{3})(t::PML, thickness::Number,gridtype::GridType= p̂) 	
sim(t,x̂, thickness,gridtype)	
sim(t,ŷ, thickness,gridtype)	
sim(t,ẑ, thickness,gridtype)				
end	