export x̂ , ŷ , ẑ
export HIGH , LOW


abstract type  Direction end
	
struct X̂ <: Direction end
struct Ŷ <: Direction end
struct Ẑ <: Direction end

const x̂ = X̂()
const ŷ = Ŷ()
const ẑ = Ẑ()

indx(::X̂) = 1
indx(::Ŷ) = 2
indx(::Ẑ) = 3

abstract type Side end
struct High <: Side end
struct Low  <: Side end

const HIGH = High()
const LOW = Low()


const Float = typeof(0.0)
const NT = NTuple
