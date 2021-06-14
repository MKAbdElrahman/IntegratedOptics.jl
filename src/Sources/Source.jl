export Source
mutable struct Source{N,T,NC}
	src::Array{T,NC}
	grid::Grid{N}	
end

function Base.getindex(src::Source,dir::Direction{D}) where D
	 @views src.src[:,:,D]
end
function Source(grid::Grid{N}) where N
		z = zeros(CFloat, size(grid)...,3)					
		return Source(z,grid)	
end	
function Base.show(io::IO, sf::Source{N,T,NC}) where {N,T,NC}
        print(io, "$(N)D source with $(NC) components\n")
end		
function (src::Source)(dir::Direction,s::AbstractArray)
      	src[dir] .=  s
end
function (src::Source)(dir::Direction,valueF::Function,maskF::Function = (x -> true))
       update!(src[dir],src.grid,maskF,valueF, p̂)	
end