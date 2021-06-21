export solve!


struct FDFDSolver end
const solve! = FDFDSolver()




struct Partial end
struct Curl end
struct CurlCurl end
struct CurlμⁱCurl end
struct μⁱCurl end



struct Partialₛ end
struct Curlₛ end
struct CurlₛCurlₛ end
struct CurlₛμⁱCurlₛ end
struct μⁱCurlₛ end

const ∂ = Partial()
const ∇x = Curl()
const ∇x∇x = CurlCurl()
const ∇xμⁱ∇x = CurlμⁱCurl()
const μⁱ∇x =  μⁱCurl()


const ∂ₛ = Partialₛ()
const ∇ₛx = Curlₛ()
const ∇ₛx∇ₛx = CurlₛCurlₛ()
const ∇ₛxμⁱ∇ₛx = CurlₛμⁱCurlₛ()
const μⁱ∇ₛx = μⁱCurlₛ()


include("kron.jl")
include("Utils.jl")
include("Partial.jl")
include("Curl.jl")
include("CurlCurl.jl")


struct EpsI end
const ϵᵣI = EpsI()

struct SystemMatrix end
const system_matrix = SystemMatrix()

struct SourceVector end
const source_vector = SourceVector()

struct QTFSF end
const  tfsf = QTFSF();

######################################################################

function (sim::Simulation)(::FDFDSolver; linearsolver::AbstractLinearSolver = LU()) 
     A = sim(system_matrix)
     b = sim(source_vector)
     Q = sim(tfsf)
     xe = sim.activate_tfsf ? linsolve(A,(Q*A - A*Q)*b ,linearsolver) :   linsolve(A,b,linearsolver)
     xh =  sim( μⁱ∇ₛx  ) * xe
     (Ex,Ey,Ez)  =  sim(reshapefield,xe)
      sim.Ez = Ex
      sim.Ez = Ey
      sim.Ez = Ez
      (Hx,Hy,Hz)  =  sim(reshapefield,xh)
      sim.Hx = Hx
      sim.Hy = Hy
      sim.Hz = Hz
  return nothing
end
#####################################################################


function (sim::Simulation)(::SystemMatrix)
     sim(∇ₛxμⁱ∇ₛx) - (2pi/sim.λ₀)^2*sim(ϵᵣI)
end	
  
function (sim::Simulation)(::SourceVector)
     sim(convert_to_vector,:J)
end	
  

########################################################################
function (sim::Simulation)(::EpsI)
     sim(convert_to_diagonal_matrix,:ϵᵣ)
end	
#########################################################################
function (sim::Simulation)(::QTFSF)
     sim(convert_to_diagonal_matrix,:Q)
end	
#########################################################################