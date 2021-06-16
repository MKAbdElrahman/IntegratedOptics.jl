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