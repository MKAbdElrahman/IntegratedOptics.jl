export Grid, Coordinate ,Coordinates , dimension , extent , spacing , ncells , range 
export directions


struct Grid{N}
    extent::NTuple{N,Float}
    spacing::NTuple{N,Float}
	size::NTuple{N,Int}	
end
	
function  Grid(; extent ,  spacing)
		 length(extent) == length(spacing) ||
         throw(error("spacing and extent must have equal length"))
         N = length(extent)
		 size = round.(Int,extent ./ spacing)
return   Grid(NTuple{N,Float}(extent),NTuple{N,Float}(spacing),NTuple{N,Int}(size))
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
	(Ind.I .- 1)  .* δ  .+  0.5 .* δ 
end	
"""
	Coordinate(g::Grid , ::GridType{:Primal}, Ind::CartesianIndex)

Returns the equivalent primal coordinate of of a `CartesianIndex`.
	
The function doesnot chack for being inside the grid.	
"""
function Coordinate(g::Grid , ::GridType{:Primal}, Ind::CartesianIndex)
	δ =  spacing(g)
	(Ind.I .- 1) .* δ  
end

_ind(gt::GridType,g::Grid{ND},coor::NTuple{ND,Number}) where ND =  ntuple(i-> _ind(gt,g,coor[i],Direction{i}()),ND)
_ind(::GridType{:Dual},g::Grid,coordinate::Number,dir::Direction) =  1 + round(Int,(coordinate - 0.5 .* spacing(g,dir))  ./ spacing(g,dir))	
_ind(::GridType{:Primal},g::Grid,coordinate::Number, dir::Direction) =  1 + round(Int,coordinate / spacing(g,dir))		

function Base.CartesianIndex(g::Grid{ND},gt::GridType,coordinate::NTuple{ND,Number}) where ND
 	CartesianIndex(_ind(gt,g,coordinate))		
end		

function Base.CartesianIndex(g::Grid{ND},gt::GridType,coordinate::Real,dir::Direction) where ND
 	CartesianIndex(_ind(gt,g,coordinate,dir))		
end	

# FIXME 	
function Base.CartesianIndices(g::Grid{ND},dir::Direction{D}, r::UnitRange{Int}) where {ND,D}
	selectdim(CartesianIndices(g),D,r)
end	
#####
	
function _convert2ind(gt::GridType,r::Tuple{Direction{D},Real,Real},g::Grid{N}) where {N,D}
	a,b = r[2],r[3] ; ax = r[1]
	ia = _ind(gt,g,a,ax)
	ib = _ind(gt,g,b,ax)
	return(ia:ib)
end	
function Base.CartesianIndices(gt::GridType,g::Grid{N},r) where {N}
	 inds = [_convert2ind(gt, r[i],g) for i in 1:N]
	CartesianIndices((inds...,))
end

	
directions(g::Grid{1}) = (x̂,)
directions(g::Grid{2}) = (x̂,ŷ) 
directions(g::Grid{3}) = (x̂,ŷ,ẑ)   