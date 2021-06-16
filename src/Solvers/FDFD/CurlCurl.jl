function (sim::Simulation)(::CurlCurl)
    sim(∇x, d̂) * sim(∇x, p̂)
end
 
function (sim::Simulation)(::CurlμⁱCurl)
    μxi =    spdiagm((1  ./ get_μ_comp(sim,  x̂))[:]) 
    μyi =    spdiagm((1  ./ get_μ_comp(sim,  ŷ))[:])
    μzi =    spdiagm((1  ./ get_μ_comp(sim,  ẑ))[:]) 
    O = spzeros(ncells(sim.grid),ncells(sim.grid));
    μi = [μxi    O     O;
            O    μyi     O;
            O     O     μzi
        ]

    sim(∇x, d̂) *  μi  * sim(∇x, p̂)
end


function (sim::Simulation)(::CurlₛCurlₛ)
    sim(∇ₛx, d̂) * sim(∇ₛx, p̂)
end
   
function (sim::Simulation)(::CurlₛμⁱCurlₛ)
    μxi =    spdiagm((1  ./ get_μ_comp(sim,  x̂))[:]) 
    μyi =    spdiagm((1  ./ get_μ_comp(sim,  ŷ))[:])
    μzi =    spdiagm((1  ./ get_μ_comp(sim,  ẑ))[:]) 
    O = spzeros(ncells(sim.grid),ncells(sim.grid));
    μi =  [ μxi     O       O;
               O      μyi     O;
               O      O     μzi
         ]

    sim(∇ₛx, d̂) *  μi  * sim(∇ₛx, p̂)
end	
