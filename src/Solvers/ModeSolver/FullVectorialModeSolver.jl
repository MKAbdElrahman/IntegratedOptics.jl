export solve_for_modes , attachmode!


function solve_for_modes end

function  attachmode! end


function (sim::Simulation{Dim})(::typeof(attachmode!), mode  , src_comp, dir::Direction{D}, p::Real) where {Dim,D}
    ind =   round(Int, p / spacing(sim.grid ,dir )  )
    input = selectdim(src_comp, D , ind)
    input .= mode
end


function (sim::Simulation)(::typeof(solve_for_modes); solver = EigArpack(), args... )
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
    eigsolve(A, solver ; args... )
end
