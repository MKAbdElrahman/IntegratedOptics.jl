export extractor, extractreshape



function convert_to_diagonal_matrix end
function convert_to_vector  end

function (sim::Simulation)(::typeof(convert_to_diagonal_matrix),symbol::Symbol)

    fx  =   spdiagm(sim(symbol,x̂)[:])
    fy  =   spdiagm(sim(symbol,ŷ)[:])
    fz  =   spdiagm(sim(symbol,ẑ)[:])
    O = spzeros(ncells(sim.grid),ncells(sim.grid));

             [  fx     O      O;
                O     fy      O;
                O      O      fz
             ]
end

function (sim::Simulation)(::typeof(convert_to_vector),symbol::Symbol)

    fx  =   sim(symbol,x̂)[:]
    fy  =   sim(symbol,ŷ)[:]
    fz  =   sim(symbol,ẑ)[:]
    [fx ; fy ; fz]

end


function Base.kron(∂::SparseMatrixCSC, dir::Direction, g::Grid{1})
    return ∂
end
  
function Base.kron(∂::SparseMatrixCSC, dir::Direction, g::Grid{2}) 
    if dir == x̂
       Iy =  I(size(g,2)) 	
       return kron(Iy , ∂)
    elseif dir == ŷ
       Ix =  I(size(g,1)) 	
       return  kron(∂ , Ix)
    end	
end
  
function Base.kron(∂::SparseMatrixCSC, dir::Direction, g::Grid{3}) 
    nx,ny,nz = size(g)
    Iz =  I(nz) ; Iy =  I(ny) ; Ix = I(nx)
    if dir == x̂
    return kron(Iz , Iy , ∂)
    end
    if dir == ŷ
    return  kron(Iz ,∂ , Ix)
    end
    if dir == ẑ
    return   kron(∂ ,Iy , Ix)
    end
end	


function extractor end
function extractreshape end


function (sim::Simulation)(::typeof(extractor), F::AbstractVector, dir::Direction{ND}) where ND
    g = sim.grid
    Nw = ncells(g);
    f =  F[((ND-1)*Nw +1) : (ND*Nw)];
end

function (sim::Simulation)(::typeof(extractreshape), F::AbstractVector, dir::Direction)
    f = sim(extractor,F,dir)
        sim(reshape,f)
end

function (sim::Simulation)(::typeof(reshape), F::AbstractVector)
    g = sim.grid
    F = reshape(F,size(g));
    return F
end


