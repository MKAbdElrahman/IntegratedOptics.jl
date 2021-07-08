
function ∂ end

function ∂(::GridType{:Primal},grid::Grid{Dim},dir::Direction{D}, F::AbstractArray) where {Dim,D}
    shifts = -1 .* (ntuple(identity,Val(Dim)) .== D)
	if D > Dim return zeros(CFloat, size(grid)) end
    (circshift(F,shifts) - F) / spacing(grid,dir)
end

function ∂(::GridType{:Dual},grid::Grid{Dim},dir::Direction{D}, F::AbstractArray) where {Dim,D}
    shifts = 1 .* (ntuple(identity,Val(Dim)) .== D)
	 if D > Dim return zeros(CFloat, size(grid)) end
    (circshift(F,shifts) - F) / spacing(grid,dir)
end