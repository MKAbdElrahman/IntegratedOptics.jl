export solve_for_modes , attachmode!

struct FullVectorialModeSolver end

const solve_for_modes = FullVectorialModeSolver()

struct AttachMode end
const attachmode! = AttachMode()

function (sim::Simulation{Dim})(::AttachMode, mode  , src_comp, dir::Direction{D}, point::Tuple) where {Dim,D}
    ind =   CartesianIndex(sim.grid,p̂,point)[D]
    input = selectdim(src_comp, D , ind)
    input .= mode
end


function (sim::Simulation)(ms::FullVectorialModeSolver)
    Ux = sim(∂,x̂,p̂) ; Vx =  sim(∂,x̂,d̂)
    Uy = sim(∂,ŷ,p̂) ; Vy =  sim(∂,ŷ,d̂)
      ϵrx = sim.ϵᵣ_xx ; ϵry = sim.ϵᵣ_yy  ; ϵrz = sim.ϵᵣ_zz    
    μrx = sim.μᵣ_xx ; μry = sim.μᵣ_yy  ; μrz = sim.μᵣ_zz    
    n = ncells(sim.grid)
    ω = (2pi/sim.λ₀)
    c = im*ω  ;  O = spzeros(n,n)
    tospdiagm(M) = spdiagm(0=> M[:])
    toinvspdiagm(M) = spdiagm(0=> 1 ./ M[:])
    id(M) = toinvspdiagm(M) ; d(M) = tospdiagm(M)
    iϵz = id(ϵrz)  ; iμz = id(μrz)

    L = c * [-d(ϵry) O; O d(ϵrx)]+(1/c)*[Vx*iμz*Ux -Vx*iμz*Uy; Vy*iμz*Ux  -Vy*iμz*Uy]
    S = c * [-d(μrx) O; O d(μry)]+(1/c)*[Uy*iϵz*Vy -Uy*iϵz*Vx; Ux*iϵz*Vy  -Ux*iϵz*Vx ]

    A = -S*L 
    eigs(A, which = :LR)
end
