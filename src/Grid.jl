
export Grid,  x⃗e ,  x⃗c , dimension , extent , spacing , ncells , range ,coord2index

import Base: size , Generator , CartesianIndices , range



struct Grid{N}
    extent::NT{N,Float}
    spacing::NT{N,Float}
	size::NT{N,Int}	
end

dimension(grid::Grid{ND}) where {ND} = ND
extent(g::Grid) = g.extent
extent(g::Grid,d::Direction) =  g.extent[indx(d)]

spacing(g::Grid) = g.spacing
spacing(g::Grid,d::Direction) = g.spacing[indx(d)]
	
Base.size(g::Grid) =  g.size
	
"""
    Grid(; extent ,  spacing)

Grid constructor.
"""	
function  Grid(; extent ,  spacing)
		 length(extent) == length(spacing) ||
         throw(error("spacing and extent must have equal length"))
         N = length(extent)
		 size = round.(Int,extent ./ spacing)
return   Grid(NT{N,Float}(extent),NT{N,Float}(spacing),NT{N,Int}(size))
end


size(g::Grid,d::Int)  =  g.size[d]
size(g::Grid,d::Direction) = g.size[indx(d)]
ncells(g::Grid)  =  prod(size(g))

range(g::Grid,dir::Direction) =   spacing(g,dir) * (1 : size(g,dir))

	
CartesianIndices(g::Grid) = CartesianIndices(size(g))
	
function CartesianIndices(g::Grid{ND},dir::Direction,side::Low,ncells::Int = 10) where ND
r = 1 : ncells 
CartesianIndices(ntuple(i -> (indx(dir) == i) ? r : size(g,i), ND))	
end

function CartesianIndices(g::Grid{ND},dir::Direction,side::High,ncells::Int = 10) where ND
N = size(g,dir)
r = N - ncells + 1 : N 
CartesianIndices(ntuple(i -> (indx(dir) == i) ? r : size(g,i), ND))	
end
	
	
function x⃗c(g::Grid)::Generator
	x⃗c(g , CartesianIndices(g))
end	
function x⃗e(g::Grid)::Generator
	x⃗e(g , CartesianIndices(g))
end	

function x⃗c(g::Grid , CIns::CartesianIndices)::Generator
	δ =  spacing(g)
	(x⃗c(g , i) for i in CIns)
end
	
	
function x⃗e(g::Grid , CIns::CartesianIndices)::Generator
	δ =  spacing(g)
	( x⃗e(g , i)  for i in CIns)
end		
	
function x⃗c(g::Grid , Ind::CartesianIndex)
	δ =  spacing(g)
	Ind.I .* δ  .+  0.5 .* spacing(g) 
end	

function x⃗e(g::Grid , Ind::CartesianIndex)
	δ =  spacing(g)
	Ind.I .* δ  
end	
"""
	coord2index(g::Grid{2},p)
returns the integer indices for a coordinate.
"""	
function coord2index(g::Grid{2},p)
   round.(Int,p ./ spacing(g)) 
end

function Base.show(io::IO, g::Grid)
        print(io, "dimension:  $(dimension(g))\n",
			      "size     :  ",size(g), '\n',
                  "extent   :  ",extent(g), '\n',
                  "spacing  :  ",spacing(g))
end



