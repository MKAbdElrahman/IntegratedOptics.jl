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


function (pw::PlaneWave)(src::Source, maskF::Function=(x -> true),gridtype::GridType= p̂)	 		
update!(src[x̂],src.grid, maskF ,x -> pw.a * exp(-im * dot(pw.k̂, x)) * pw.ê[1], p̂)
update!(src[ŷ],src.grid, maskF ,x -> pw.a * exp(-im * dot(pw.k̂, x)) * pw.ê[2], p̂)
update!(src[ẑ],src.grid, maskF ,x -> pw.a * exp(-im * dot(pw.k̂, x)) * pw.ê[3], p̂)	
end
    