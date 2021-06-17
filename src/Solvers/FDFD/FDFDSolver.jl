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
include("Partial.jl")
include("Curl.jl")
include("CurlCurl.jl")



struct EpsI end
const ϵᵣI = EpsI()

struct SystemMatrix end
const system_matrix = SystemMatrix()

struct LoadVector end
const source_vector = LoadVector()

struct QTFSF end
const  tfsf = QTFSF();

######################################################################

function (sim::Simulation)(::FDFDSolver, ls::AbstractLinearSolver)
     A = sim(system_matrix)
     b = sim(source_vector)
     Q = sim(tfsf)
     sim.activate_tfsf ? linsolve(A,(Q*A - A*Q)*b ,ls) :   linsolve(A,b,ls)
end
#####################################################################


function (sim::Simulation)(::SystemMatrix)
     sim(∇ₛxμⁱ∇ₛx) - (2pi/sim.λ₀)^2*sim(ϵᵣI)
end	
  
function (sim::Simulation)(::LoadVector)
[ get_src_comp(sim, x̂)[:] ; get_src_comp(sim, ŷ)[:] ; get_src_comp(sim, ẑ)[:]  ] 
end	
  

########################################################################
function (sim::Simulation)(::EpsI)
     ϵx =    spdiagm((get_ϵ_comp(sim,  x̂))[:]) 
     ϵy =    spdiagm((get_ϵ_comp(sim,  ŷ))[:])
     ϵz =    spdiagm((get_ϵ_comp(sim,  ẑ))[:]) 
     O = spzeros(ncells(sim.grid),ncells(sim.grid));
           [ ϵx     O       O;
                 O     ϵy      O;
                O     O     ϵz
            ]
end	
#########################################################################
function (sim::Simulation)(::QTFSF)
     QM =    spdiagm(sim.Q[:]) 
     O = spzeros(ncells(sim.grid),ncells(sim.grid));
           [ QM     O       O;
                 O     QM      O;
                O     O     QM
            ]
end	
#########################################################################