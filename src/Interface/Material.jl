export setϵᵣ! ,  setμᵣ! , setmaterial! , setbackground!
export Material
export ϵ₁ , ϵ₂ , n , κ


function  setϵᵣ! end
function  setμᵣ! end
function  setmaterial! end
function  setbackground! end
    

struct Material{T1,T2,T3,T4,T5,T6}
    ϵr_xx::T1
    ϵr_yy::T2
    ϵr_zz::T3
    μr_xx::T4
    μr_yy::T5
    μr_zz::T6
end


function Material( ; ϵᵣ::Number)
    Material(ϵᵣ,ϵᵣ,ϵᵣ,1,1,1)
end


function (sim::Simulation)(::typeof(setmaterial!), mat::Material, region)
    sim(setϵᵣ!,x̂,x -> mat.ϵr_xx,region)
    sim(setϵᵣ!,ŷ,x -> mat.ϵr_yy,region)
    sim(setϵᵣ!,ẑ,x -> mat.ϵr_zz,region)

    sim(setμᵣ!,x̂,x -> mat.μr_xx,region)
    sim(setμᵣ!,ŷ,x -> mat.μr_yy,region)
    sim(setμᵣ!,ẑ,x -> mat.μr_zz,region)
end



function (sim::Simulation)(::typeof(setbackground!), mat::Material)
    sim(setϵᵣ!,x̂,x -> mat.ϵr_xx,EVERYWHERE)
    sim(setϵᵣ!,ŷ,x -> mat.ϵr_yy,EVERYWHERE)
    sim(setϵᵣ!,ẑ,x -> mat.ϵr_zz,EVERYWHERE)

    sim(setμᵣ!,x̂,x -> mat.μr_xx,EVERYWHERE)
    sim(setμᵣ!,ŷ,x -> mat.μr_yy,EVERYWHERE)
    sim(setμᵣ!,ẑ,x -> mat.μr_zz,EVERYWHERE)
end


function get_ϵ_comp(sim::Simulation{Dim},  dir::Direction{D}) where {D,Dim}
	if D == 1 return sim.ϵᵣ_xx end
	if D == 2 return sim.ϵᵣ_yy end
	if D == 3 return sim.ϵᵣ_zz end
end

function get_μ_comp(sim::Simulation{Dim},  dir::Direction{D}) where {D,Dim}
	if D == 1 return sim.μᵣ_xx end
	if D == 2 return sim.μᵣ_yy end
	if D == 3 return sim.μᵣ_zz end
end	

function (sim::Simulation)(::typeof(setϵᵣ!),dir::Direction,val::Function, reg = EVERYWHERE , gridtype::GridType= p̂) 
sim(set!, get_ϵ_comp(sim,  dir),val,reg,gridtype)	
end		

function (sim::Simulation)(::typeof(setμᵣ!),dir::Direction,val::Function, reg = EVERYWHERE , gridtype::GridType = d̂) 
sim(set!, get_μ_comp(sim,  dir),val,reg,gridtype)	
end		


ϵ₁(n::Real,κ::Real) = n^2 - κ^2
ϵ₂(n::Real,κ::Real) = 2*n*κ

n(ϵ₁::Real,ϵ₂::Real) = 1/sqrt(2)  * sqrt(ϵ₁  + sqrt(ϵ₁^2 + ϵ₂^2))
κ(ϵ₁::Real,ϵ₂::Real) = 1/sqrt(2)  * sqrt(-ϵ₁ + sqrt(ϵ₁^2 + ϵ₂^2))
