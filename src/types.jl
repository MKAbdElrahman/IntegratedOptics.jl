export x̂ , ŷ , ẑ
export HIGH , LOW


struct Direction{T} end	
const x̂ = Direction{1}()
const ŷ = Direction{2}()	
const ẑ = Direction{3}()	
	
	
struct GridType{T} end	
const p̂ = GridType{:Primal}()
const d̂ = GridType{:Dual}()	



abstract type Side end
struct High <: Side end
struct Low  <: Side end

const HIGH = High()
const LOW = Low()


const Float = typeof(0.0)
const CFloat = Complex{Float}
const NT = NTuple
