export Simulation
include("Grid.jl")	

export  set!,add!

Base.@kwdef mutable struct Simulation{Dim}

		grid::Grid{Dim}
		
		λ₀::Float

		J_x::Array{CFloat,Dim} = zeros(CFloat,size(grid))
		J_y::Array{CFloat,Dim} = zeros(CFloat,size(grid))
		J_z::Array{CFloat,Dim} = zeros(CFloat,size(grid))
		
		Q::BitArray{Dim}	 = falses(size(grid))
		
		S_x::Array{CFloat,Dim} = ones(CFloat,size(grid))
		S_y::Array{CFloat,Dim} = ones(CFloat,size(grid))
		S_z::Array{CFloat,Dim} = ones(CFloat,size(grid))
		
		activate_tfsf::Bool = false

		
		ϵᵣ_xx::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		ϵᵣ_yy::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		ϵᵣ_zz::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		
		μᵣ_xx::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		μᵣ_yy::Array{CFloat,Dim}  = ones(CFloat,size(grid))
		μᵣ_zz::Array{CFloat,Dim}  = ones(CFloat,size(grid))

        e⁻ⁱᵏᴸ::NTuple{Dim,CFloat} = ntuple(i -> CFloat(1.0 + 0.0im) , dimension(grid))

		E::Vector{CFloat}   = zeros(CFloat,3*ncells(grid))
		H::Vector{CFloat}   = zeros(CFloat,3*ncells(grid)) 

		sysetm_matrix::SparseMatrixCSC{CFloat} = spzeros(CFloat,3*ncells(grid),3*ncells(grid))
		source_vector::Vector{CFloat}   = zeros(CFloat,3*ncells(grid)) 

		E_adjoint::Vector{CFloat}   = zeros(CFloat,3*ncells(grid))
		sensitivity::Vector{CFloat}  = zeros(CFloat,3*ncells(grid))
	end
	
function Base.show(io::IO, sim::Simulation{Dim}) where {Dim}
        print(io, "A $(Dim)D Simulation is initialized.\n")
end	

function set! end

function add! end



function (sim::Simulation)(::typeof(add!),m::AbstractArray,valueF::Function,maskF::Function =  (x -> true) ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
	vals = valueF.(Coordinates(sim.grid,gridtype));
	m[mask] .+= vals[mask];	
end

function (sim::Simulation)(::typeof(add!),m::AbstractArray,vals::AbstractArray,maskF::Function =  (x -> true) ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
	m[mask] .+= vals[mask];	
end

function (sim::Simulation)(::typeof(set!),m::AbstractArray,valueF::Function,maskF::Function =  (x -> true) ,gridtype::GridType = p̂)
	mask = maskF.(Coordinates(sim.grid,gridtype))
	vals = valueF.(Coordinates(sim.grid,gridtype));
	m[mask] = vals[mask];	
end


function (sim::Simulation)(sym::Symbol,dir::Direction, maskF::Function) 
	mat = sim(sym,dir) 
	mask = maskF.(Coordinates(sim.grid,p̂))
	mat[mask]
end



function (sim::Simulation)(sym::Symbol,dir::Direction) 

    !(sym === :ϵᵣ && x̂ == dir ) || return sim.ϵᵣ_xx
	!(sym === :ϵᵣ && ŷ == dir ) || return sim.ϵᵣ_yy
	!(sym === :ϵᵣ && ẑ == dir ) || return sim.ϵᵣ_zz

	!(sym === :μᵣ && x̂ == dir ) || return sim.μᵣ_xx
	!(sym === :μᵣ && ŷ == dir ) || return sim.μᵣ_yy
	!(sym === :μᵣ && ẑ == dir ) || return sim.μᵣ_zz

	!(sym === :J && x̂ == dir ) || return sim.J_x
	!(sym === :J && ŷ == dir ) || return sim.J_y
	!(sym === :J && ẑ == dir ) || return sim.J_z

	!(sym === :S && x̂ == dir ) || return sim.S_x
	!(sym === :S && ŷ == dir ) || return sim.S_y
	!(sym === :S && ẑ == dir ) || return sim.S_z


	!(sym === :Q && x̂ == dir ) || return sim.Q
	!(sym === :Q && ŷ == dir ) || return sim.Q
	!(sym === :Q && ẑ == dir ) || return sim.Q


	!(sym === :E && x̂ == dir ) || return  sim(ExtractReshape(),sim.E,x̂)
	!(sym === :E && ŷ == dir ) || return  sim(ExtractReshape(),sim.E,ŷ)
	!(sym === :E && ẑ == dir ) || return  sim(ExtractReshape(),sim.E,ẑ)

	!(sym === :H && x̂ == dir ) || return  sim(ExtractReshape(), sim( μⁱ∇ₛx  ) * sim.E,x̂)
	!(sym === :H && ŷ == dir ) || return  sim(ExtractReshape(), sim( μⁱ∇ₛx  ) * sim.E,ŷ)
	!(sym === :H && ẑ == dir ) || return  sim(ExtractReshape(), sim( μⁱ∇ₛx  ) * sim.E,ẑ)

	!(sym === :sensitivity && x̂ == dir ) || return  sim(ExtractReshape(),  sim.sensitivity,x̂)
	!(sym === :sensitivity && ŷ == dir ) || return  sim(ExtractReshape(),  sim.sensitivity,ŷ)
	!(sym === :sensitivity && ẑ == dir ) || return  sim(ExtractReshape(),  sim.sensitivity,ẑ)

end

include("Material.jl")
include("TFSF.jl")
include("PML.jl")
include("Sources/Source.jl")
include("BC.jl")
include("SliceSimulation.jl")