
function ∂  end
function ∂ₛ end



  ########################################################################################## 

function (sim::Simulation)(::typeof(∂),dir::Direction,gridtype::GridType) 
    D(dir,sim.grid,sim.e⁻ⁱᵏᴸ,gridtype)	
end	
 
 
   
function (sim::Simulation)(::typeof(∂ₛ),dir::Direction,gridtype::GridType) 
       S =  get_S_comp(sim,  dir) 
       spdiagm((1 ./ S)[:])  *  sim(∂,dir,gridtype)
end	
   
  ########################################################################################## 
   
  function D(dir::Direction{NDir},g::Grid{NDim},e⁻ⁱᵏᴸ::NTuple,gridtype::GridType) where {NDim,NDir}
      if NDir > NDim return spzeros(ncells(g),ncells(g)) end
      dw = spacing(g,dir);
      nw = size(g,dir);
      ∂w = D(nw,e⁻ⁱᵏᴸ[NDir],gridtype) / dw;
      return kron(∂w, dir, g)
    end
    
 ################################################################################
 function  D(N::Int, e⁻ⁱᵏᴸ::Number,gridtype::GridType{:Primal})
    T = promote_type(Float, eltype(e⁻ⁱᵏᴸ))
    Df =  spdiagm(0=>  -ones(T,N),1=> ones(T,N-1))
    Df[N,1] =  1.0 * e⁻ⁱᵏᴸ
    return  Df
 end
 
 
 function  D(N::Int, e⁻ⁱᵏᴸ::Number,gridtype::GridType{:Dual})
    T = promote_type(Float, eltype(e⁻ⁱᵏᴸ))
    Db =  spdiagm(0=> ones(T,N),  -1=> -ones(T,N-1))
    Db[1,N] = -1.0 * (e⁻ⁱᵏᴸ)^-1 	
    return  Db
 end
 #############################################################################
 