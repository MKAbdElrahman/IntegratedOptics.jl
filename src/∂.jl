export ∂
function  ∂(::Periodic,N::Int,dx::Real)
    D =  spdiagm(0=> -ones(N),1=> ones(N-1))
    D[N,1] = one(dx)
    return -D' / dx ,  D / dx 
 end
 function  ∂(::Bloch,N::Int,dx::Real, e⁻ⁱᵏᴸ::Number)
    T = promote_type(Float, eltype(e⁻ⁱᵏᴸ))
    d = -ones(T,N)
    u =  ones(T,N-1)
    Df =  spdiagm(0=>  -ones(T,N),1=> ones(T,N-1))
    Db =  spdiagm(0=> ones(T,N),  -1=> -ones(T,N-1))
    Df[N,1] =  1.0 * e⁻ⁱᵏᴸ
    Db[1,N] = -1.0 * (e⁻ⁱᵏᴸ)^-1 	
    return  Db / dx , Df / dx
 end
 function  ∂(::NeumannDirichlet,N::Int,dx::Real)
    D =  spdiagm(0=>  -ones(N),1=>  ones(N-1))
    return -D' / dx ,  D / dx
 end
 function  ∂(::DirichletNeumann,N::Int,dx::Real)
    D =  spdiagm(0=>  -ones(N),1=>  ones(N-1))
    return  D / dx , -D' / dx 
 end
 function  ∂(::DirichletDirichlet,N::Int,dx::Real)
    throw(error("Not Implemented"))
 end
 function  ∂(::NeumannNeumann,N::Int,dx::Real)
    Df =  spdiagm(0=> -ones(N),1=> ones(N-1))
    Db =  spdiagm(0=> ones(N),-1=> -ones(N-1))
    Df[N,N]  = 0
    return  Db / dx , Df / dx 
 end


 function ∂(bc::BCType,dir::Direction,g::Grid{D}) where D
    if Int(dir) > D return (spzeros(ncells(g),ncells(g)) , spzeros(ncells(g),ncells(g))) end
    dw = g.spacing[Int(dir)];
    nw = size(g, Int(dir));
    ∂w = ∂(bc,nw,dw);
    return kron(∂w[1], dir, g) , kron(∂w[2], dir, g)
 end

 function ∂(bc::Bloch,dir::Direction,g::Grid{D},e⁻ⁱᵏᴸ::Number = 1.0) where D
   if Int(dir) > D return (spzeros(ncells(g),ncells(g)) , spzeros(ncells(g),ncells(g))) end
   dw = g.spacing[Int(dir)];
   nw = size(g, Int(dir));
   ∂w = ∂(bc,nw,dw,e⁻ⁱᵏᴸ);
   return kron(∂w[1], dir, g) , kron(∂w[2], dir, g)
end


function Base.kron(∂::SparseMatrixCSC, dir::Direction, g::Grid{1})
   return ∂
end

function Base.kron(∂::SparseMatrixCSC, dir::Direction, g::Grid{2}) 
   if dir == X
      Iy =  I(size(g,2)) 	
      return kron(Iy , ∂)
   elseif dir == Y
      Ix =  I(size(g,1)) 	
      return  kron(∂ , Ix)
   end	
end

function Base.kron(∂::SparseMatrixCSC, dir::Direction, g::Grid{3}) 
   nx,ny,nz = size(g)
   Iz =  I(nz) ; Iy =  I(ny) ; Ix = I(nx)
   if dir == X
   return kron(Iz , Iy , ∂)
   end
   if dir == Y
   return  kron(Iz ,∂ , Ix)
   end
   if dir == Z
   return   kron(∂ ,Iy , Ix)
   end
 end	