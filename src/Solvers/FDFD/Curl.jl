
##########################################################################
function (sim::Simulation)(::Curl,gridtype::GridType) 
    ∂x =   sim(∂, x̂,gridtype);
    ∂y =   sim(∂, ŷ,gridtype);
    ∂z =   sim(∂, ẑ,gridtype);
    O = spzeros(ncells(sim.grid),ncells(sim.grid));
     c = [O    -∂z     ∂y;
            ∂z     O     -∂x;
          -∂y    ∂x      O
        ]
end
function (sim::Simulation)(::Curlₛ,gridtype::GridType) 
    ∂x =   sim(∂ₛ, x̂,gridtype);
    ∂y =   sim(∂ₛ, ŷ,gridtype);
    ∂z =   sim(∂ₛ, ẑ,gridtype);
    O = spzeros(ncells(sim.grid),ncells(sim.grid));
     c = [O    -∂z     ∂y;
            ∂z     O     -∂x;
          -∂y    ∂x      O
        ]
end	
###########################################################################