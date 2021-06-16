
export Grid, Coordinate ,Coordinates , dimension , extent , spacing , ncells , range 



struct Grid{N}
    extent::NT{N,Float}
    spacing::NT{N,Float}
	size::NT{N,Int}	
end
	
function  Grid(; extent ,  spacing)
		 length(extent) == length(spacing) ||
         throw(error("spacing and extent must have equal length"))
         N = length(extent)
		 size = round.(Int,extent ./ spacing)
return   Grid(NT{N,Float}(extent),NT{N,Float}(spacing),NT{N,Int}(size))
end
	
function Base.show(io::IO, g::Grid)
        print(io, "dimension:  $(dimension(g))\n",
			      "size     :  ",size(g), '\n',
                  "extent   :  ",extent(g), '\n',
                  "spacing  :  ",spacing(g))
end


	
dimension(grid::Grid{ND}) where {ND} = ND
	
extent(g::Grid) = g.extent
extent(g::Grid,d::Int)  =  g.extent[d]		
extent(g::Grid,d::Direction{T}) where T =  g.extent[T]
	
spacing(g::Grid) = g.spacing
spacing(g::Grid,d::Int)  =  g.spacing[d]	
spacing(g::Grid,d::Direction{T}) where T = g.spacing[T]
	
Base.size(g::Grid) =  g.size
Base.size(g::Grid,d::Int)  =  g.size[d]
Base.size(g::Grid,d::Direction{T}) where T = g.size[T]
ncells(g::Grid)  =  prod(size(g))

	
Base.range(g::Grid,dir::Direction) =   range(0,extent(g,dir),length = size(g,dir))
	
Base.CartesianIndices(g::Grid) = CartesianIndices(size(g))
	
	

"""
	  Coordinates(g::Grid,gridtype::GridType{T}) where T
Returns the primal or dual coordinates of all points on a grid.
	
"""	
function Coordinates(g::Grid,gridtype::GridType{T}) where T
	Coordinates(g , gridtype , CartesianIndices(g))
end	

"""
	 Coordinates(g::Grid,gridtype::GridType{T},CIns::CartesianIndices ) where T
Returns the primal or dual coordinates of a set of cartesian indecies.
	
"""
function Coordinates(g::Grid,gridtype::GridType{T},CIns::CartesianIndices ) where T
  ( Coordinate(g , gridtype, i )  for i in CIns)
end	
	
	
"""
	Coordinate(g::Grid ,::GridType{:Dual},Ind::CartesianIndex)

Returns the equivalent dual coordinate of of a `CartesianIndex`.
	
The function doesnot chack for being inside the grid.	
"""
function Coordinate(g::Grid ,::GridType{:Dual},Ind::CartesianIndex)
	δ =  spacing(g)
	Ind.I .* δ  .+  0.5 .* spacing(g) 
end	
"""
	Coordinate(g::Grid , ::GridType{:Primal}, Ind::CartesianIndex)

Returns the equivalent primal coordinate of of a `CartesianIndex`.
	
The function doesnot chack for being inside the grid.	
"""
function Coordinate(g::Grid , ::GridType{:Primal}, Ind::CartesianIndex)
	δ =  spacing(g)
	Ind.I .* δ  
end

""" 
	CartesianIndex(g::Grid{ND},::GridType{:Primal},  coordinate::NTuple{ND,Number})    where ND
	
Returns the equivalent priaml `CartesianIndex` of a coordinate.

"""
	

function Base.CartesianIndex(g::Grid{ND},::GridType{:Primal},  coordinate::NTuple{ND,Number}) where ND
	CartesianIndex(round.(Int,coordinate ./ spacing(g)))
end

"""
	CartesianIndex(g::Grid{ND},::GridType{:Dual},  coordinate::NTuple{ND,Number}) where ND

Returns the equivalent dual`CartesianIndex` of a coordinate.
"""	
function Base.CartesianIndex(g::Grid{ND},::GridType{:Dual},  coordinate::NTuple{ND,Number}) where ND
 CartesianIndex(round.(Int,(coordinate .- 0.5 .* spacing(g))  ./ spacing(g)))
end		
	

function Base.CartesianIndices(g::Grid{ND},dir::Direction{D}, r::UnitRange{Int}) where {ND,D}
    CartesianIndices(ntuple(i -> (D == i) ? r : size(g,i), ND))	
end
