export solve! , adjointsolve! ,  init!


struct FDFDSolver end
struct  AdjointFDFDSolver end

const solve! = FDFDSolver()
const adjointsolve! =  AdjointFDFDSolver()



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
const system_matrix! = SystemMatrix()

struct SourceVector end
const source_vector! = SourceVector()

struct TFSFSourceVector end
const set_tfsf_source_vector! = TFSFSourceVector()

struct QTFSF end
const  tfsf = QTFSF();


struct InitSystemMatrices end
const init! = InitSystemMatrices()

######################################################################

function (sim::Simulation)(::FDFDSolver; linearsolver::AbstractLinearSolver = LU())      
      linsolve!(sim.E,sim.sysetm_matrix,sim.source_vector,linearsolver)
#      sim.H =  sim( μⁱ∇ₛx  ) * sim.E
      return nothing
end

function (sim::Simulation)(::AdjointFDFDSolver,adjointsrc::AbstractVector; linearsolver::AbstractLinearSolver = LU())      
     linsolve!(sim.E_adjoint,adjoint(sim.sysetm_matrix),sim.source_vector,linearsolver)
     return nothing
end
#####################################################################


function (sim::Simulation)(::SystemMatrix)
sim.sysetm_matrix =     sim(∇ₛxμⁱ∇ₛx) - (2pi/sim.λ₀)^2*sim(ϵᵣI)
end	
  
function (sim::Simulation)(::SourceVector)
sim.source_vector =  sim(convert_to_vector,:J)
end	
  
function (sim::Simulation)(::InitSystemMatrices)
     sim(system_matrix!)
     sim(source_vector!)
     if sim.activate_tfsf  sim(set_tfsf_source_vector!)   end
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

function (sim::Simulation)(::TFSFSourceVector)
     Q = sim(tfsf)
     A = sim.sysetm_matrix
     b = sim.source_vector
     sim.source_vector = (Q*A - A*Q) * b 
end