export PML

mutable struct PML{ND}
	_grid::Grid{ND}
	_s::Array{Complex{Float},ND}	
end

"""
	 PML(g::Grid{ND})
Returns an object to be used later as functor that can be used to customize the PML length, sides and directions.	

"""	
function  PML(g::Grid{ND}) where ND
			s = ones(Complex{Float},size(g))
			return PML(g,s)
end	
_s(d::Real,L::Real;m::Real=3.5,s_min::Real= -1.0) = im*(s_min) * Complex((d/L))^m	

s(::High,x,d,l)::Complex{Float} = ( _s(x - (l - d)  ,  d))
s(::Low,x,d,l)::Complex{Float}  = (_s(-x + d , d))


	
function (pml::PML{ND})(dir::Direction,side::Side, ncells = 30) where ND		
g = pml._grid 
I =  CartesianIndices(g,dir,side,ncells) 
r  = x⃗e(g, I)
thickness  = ncells * spacing(g,dir)
l =  extent(g,dir)		
ind = indx(dir)		
pml._s[I] .+= (s(side,x[ind],thickness,l) for x in r)
return pml._s
end
	
		
function (pml::PML{ND})(dir::Direction, ncells = 30) where ND
	pml(dir,LOW,ncells)
	pml(dir,HIGH,ncells)
end
	
function (pml::PML{1})(ncells::Int = 30) 
	pml(x̂,ncells)
end
function (pml::PML{2})(ncells::Int = 30)
	pml(x̂,ncells)	
	pml(ŷ,ncells)
end	
function (pml::PML{3})(ncells::Int = 30)
	pml(x̂,ncells)	
	pml(ŷ,ncells)	
	pml(ẑ,ncells)
end	
