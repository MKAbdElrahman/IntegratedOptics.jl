
function ∇ₛx∇ₛx end
function ∇ₛxμⁱ∇ₛx end
function ∇x∇x end
function ∇xμⁱ∇x end



function (sim::Simulation)(::typeof(∇x∇x))
    sim(∇x, d̂) * sim(∇x, p̂)
end
 
function (sim::Simulation)(::typeof(∇xμⁱ∇x))
    μi =  sim(convert_to_diagonal_matrix,:μᵣ)
    sim(∇x, d̂) *  μi  * sim(∇x, p̂)
end


function (sim::Simulation)(::typeof(∇ₛx∇ₛx))
    sim(∇ₛx, d̂) * sim(∇ₛx, p̂)
end
   
function (sim::Simulation)(::typeof(∇ₛxμⁱ∇ₛx))
    μi =  sim(convert_to_diagonal_matrix,:μᵣ)
    sim(∇ₛx, d̂) *  μi  * sim(∇ₛx, p̂)
end	
