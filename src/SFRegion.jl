export SFRegion

mutable struct SFRegion{ND}
	grid::Grid{ND}
	region::Function	
	Q::BitArray{ND}	
    end
	"""
    SFRegion(g::Grid{ND},region::Function = (x-> false))
Returns a ScatteredField region defined by the boolean function `region`.	

"""	
function  SFRegion(g::Grid{ND},region::Function = (x-> false)) where ND
	Q = falses(size(g))
	update!(Q,g,x -> true, region)
	return SFRegion(g,region,Q)
end	
	
function Base.show(io::IO, sf::SFRegion{ND}) where ND
        print(io, "$(ND)D ScatteredField Region \n")
end	
function (sf::SFRegion{ND})(dir::Direction{D},side::Low, ncells = 10) where {ND,D}		
g = sf.grid 
I =  CartesianIndices(g,dir,1:ncells) 
r  = Coordinates(g,p̂, I)
thickness  = ncells * spacing(g,dir)
l =  extent(g,dir)		
sf.Q[I] .= (true for x in r)
end

function (sf::SFRegion{ND})(dir::Direction{D},side::High, ncells::Int = 10) where {ND,D}		
g = sf.grid 
I =  CartesianIndices(g,dir,(size(g,dir)-ncells):size(g,dir)) 
r  = Coordinates(g,p̂, I)
thickness  = ncells * spacing(g,dir)
l =  extent(g,dir)		
sf.Q[I] .= (true for x in r)
end	

function (sf::SFRegion{ND})(dir::Direction, ncells::Int = 10) where ND
	sf(dir,LOW,ncells)
	sf(dir,HIGH,ncells)
end
	
function (sf::SFRegion{1})(ncells::Int = 10) 
	sf(x̂,ncells)
end
function (sf::SFRegion{2})(ncells::Int = 10)
	sf(x̂,ncells)	
	sf(ŷ,ncells)
end	
function (sf::SFRegion{3})(ncells::Int = 10)
	sf(x̂,ncells)	
	sf(ŷ,ncells)	
	sf(ẑ,ncells)
end	