export PlaneWave

struct PlaneWave{ND,T} 
    k̂::NTuple{ND,T}
    ê::NTuple{3,T}
    a::T
end
function PlaneWave(; k̂::NTuple{ND,T1},ê::NTuple{3,T2},a::T3 = 1.0) where {T1,T2,T3} where ND
    T = promote_type(T1,T2,T3)
    return  PlaneWave(NTuple{ND,T}(k̂),NTuple{3,T}(ê),T(a))
end	

function (sim::Simulation)(src::Source,pw::PlaneWave, reg::Function = (x -> true), gridtype::GridType= p̂)
sim(src,x̂,x -> pw.a * exp(-im * dot(pw.k̂, x)) * pw.ê[1],reg,gridtype)	
sim(src,ŷ,x -> pw.a * exp(-im * dot(pw.k̂, x)) * pw.ê[2],reg,gridtype)		
sim(src,ẑ,x -> pw.a * exp(-im * dot(pw.k̂, x)) * pw.ê[3],reg,gridtype)			
end	
########################################################
