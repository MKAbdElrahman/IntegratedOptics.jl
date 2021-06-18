export solve_with_FDFD


struct FDFDSolver end

const solve_with_FDFD = FDFDSolver();


struct Partial end
struct Curl end
struct CurlCurl end
struct CurlμⁱCurl end



struct Partialₛ end
struct Curlₛ end
struct CurlₛCurlₛ end
struct CurlₛμⁱCurlₛ end

const ∂ = Partial()
const ∇x = Curl()
const ∇x∇x = CurlCurl()
const ∇xμⁱ∇x = CurlμⁱCurl()


const ∂ₛ = Partialₛ()
const ∇ₛx = Curlₛ()
const ∇ₛx∇ₛx = CurlₛCurlₛ()
const ∇ₛxμⁱ∇ₛx = CurlₛμⁱCurlₛ()


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

function (sim::Simulation)(::FDFDSolver, ls::AbstractLinearSolver)
     A = sim(system_matrix)
     b = sim(source_vector)
     Q = sim(tfsf)
     sim(reshapefield,sim.activate_tfsf ? linsolve(A,(Q*A - A*Q)*b ,ls) :   linsolve(A,b,ls))

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