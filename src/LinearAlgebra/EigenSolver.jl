import Arpack: eigs

abstract type AbstractEigenSolver end

struct EigArpack <: AbstractEigenSolver end

function eigsolve(A, ::EigArpack ; args...)
    eigs(A, which = :LR ; args...)
end
eigsolve(A; args...) = eigsolve(A,EigArpack() ; args...)