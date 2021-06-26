export PlaneWave


Base.@kwdef struct PlaneWave{ND} 
    k̂::NTuple{ND,Real}
    ê::NTuple{3, Real}
    a::Number = 1.0
end


function (sim::Simulation)(::typeof(setsrc!),pw::PlaneWave, reg::Function = (x -> true), gridtype::GridType= p̂)
sim(setsrc!,x̂,x -> pw.a * exp(-im * dot(pw.k̂, x)) * pw.ê[1],reg,gridtype)	
sim(setsrc!,ŷ,x -> pw.a * exp(-im * dot(pw.k̂, x)) * pw.ê[2],reg,gridtype)		
sim(setsrc!,ẑ,x -> pw.a * exp(-im * dot(pw.k̂, x)) * pw.ê[3],reg,gridtype)			
end	
########################################################
