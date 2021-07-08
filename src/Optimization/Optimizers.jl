export Descent, Momentum , Nesterov

abstract type AbstractOptimiser end
mutable struct Descent <: AbstractOptimiser
  eta::Float64
end

Descent() = Descent(0.1)

function apply!(o::Descent, x, Δ)
  Δ .*= o.eta
end




mutable struct Momentum <: AbstractOptimiser
  eta::Float64
  rho::Float64
  velocity::IdDict
end

Momentum(η = 0.01, ρ = 0.9) = Momentum(η, ρ, IdDict())

function apply!(o::Momentum, x, Δ)
  η, ρ = o.eta, o.rho
  v = get!(() -> zero(x), o.velocity, x)::typeof(x)
  @. v = ρ * v - η * Δ
  @. Δ = -v
end




mutable struct Nesterov <: AbstractOptimiser
  eta::Float64
  rho::Float64
  velocity::IdDict
end

Nesterov(η = 0.001, ρ = 0.9) = Nesterov(η, ρ, IdDict())

function apply!(o::Nesterov, x, Δ)
  η, ρ = o.eta, o.rho
  v = get!(() -> zero(x), o.velocity, x)::typeof(x)
  d = @. ρ^2 * v - (1+ρ) * η * Δ
  @. v = ρ*v - η*Δ
  @. Δ = -d
end