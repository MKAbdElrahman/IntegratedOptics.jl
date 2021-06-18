function (sim::Simulation)(::CurlCurl)
    sim(∇x, d̂) * sim(∇x, p̂)
end
 
function (sim::Simulation)(::CurlμⁱCurl)
    μi =  sim(convert_to_diagonal_matrix,:μᵣ)
    sim(∇x, d̂) *  μi  * sim(∇x, p̂)
end


function (sim::Simulation)(::CurlₛCurlₛ)
    sim(∇ₛx, d̂) * sim(∇ₛx, p̂)
end
   
function (sim::Simulation)(::CurlₛμⁱCurlₛ)
    μi =  sim(convert_to_diagonal_matrix,:μᵣ)
    sim(∇ₛx, d̂) *  μi  * sim(∇ₛx, p̂)
end	
