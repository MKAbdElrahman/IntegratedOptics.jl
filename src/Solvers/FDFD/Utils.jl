
export convert_to_diagonal_matrix
export convert_to_vector
struct ConvertToDiagonalMatrix end
struct ConvertToVector end

const convert_to_diagonal_matrix = ConvertToDiagonalMatrix()
const convert_to_vector = ConvertToVector()

function (sim::Simulation)(::ConvertToDiagonalMatrix,symbol::Symbol)

    fx  =   spdiagm(sim(symbol,x̂)[:])
    fy  =   spdiagm(sim(symbol,ŷ)[:])
    fz  =   spdiagm(sim(symbol,ẑ)[:])
    O = spzeros(ncells(sim.grid),ncells(sim.grid));

             [  fx     O      O;
                O     fy      O;
                O      O      fz
             ]
end

function (sim::Simulation)(::ConvertToVector,symbol::Symbol)

    fx  =   sim(symbol,x̂)[:]
    fy  =   sim(symbol,ŷ)[:]
    fz  =   sim(symbol,ẑ)[:]
    [fx ; fy ; fz]
end


