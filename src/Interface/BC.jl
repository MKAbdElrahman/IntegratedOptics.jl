export Periodic , Bloch, DirichletNeumann , NeumannDirichlet , NeumannNeumann , DirichletDirichlet

abstract type BCType end
struct Periodic <: BCType end
struct Bloch <: BCType end
struct DirichletNeumann <: BCType end
struct NeumannDirichlet <: BCType end
struct NeumannNeumann <: BCType end
struct DirichletDirichlet <: BCType end