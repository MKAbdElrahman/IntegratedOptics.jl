
export slice
struct SliceSimulation end
const slice = SliceSimulation();

function (sim::Simulation{Dim})(::SliceSimulation, dir::Direction{D}, p::NTuple{Dim,Real}) where {D,Dim}

dirs = directions(sim.grid)
maskdir =  dirs .!= fill(dir,Dim)

ext =  extent(sim.grid)[maskdir] 
spac=  spacing(sim.grid)[maskdir] 

sim_wg = Simulation(λ₀ = sim.λ₀ ;  grid = Grid(extent = ext , spacing =  spac ))

ind = CartesianIndex(sim.grid,p̂,p)[D]

sim_wg.src_x = selectdim(sim.src_x, D , ind)
sim_wg.src_y = selectdim(sim.src_y, D , ind)
sim_wg.src_z = selectdim(sim.src_z, D , ind)

sim_wg.Q = selectdim(sim.Q, D , ind)
sim_wg.S_x = selectdim(sim.S_x, D , ind)
sim_wg.S_y = selectdim(sim.S_y, D , ind)
sim_wg.S_z = selectdim(sim.S_z, D , ind)

sim_wg.ϵᵣ_xx = selectdim(sim.ϵᵣ_xx, D , ind)
sim_wg.ϵᵣ_yy = selectdim(sim.ϵᵣ_yy, D , ind)
sim_wg.ϵᵣ_zz = selectdim(sim.ϵᵣ_zz, D , ind)

sim_wg.μᵣ_xx = selectdim(sim.μᵣ_xx, D , ind)
sim_wg.μᵣ_yy = selectdim(sim.μᵣ_yy, D , ind)
sim_wg.μᵣ_zz = selectdim(sim.μᵣ_zz, D , ind)

sim_wg.e⁻ⁱᵏᴸ = sim.e⁻ⁱᵏᴸ[maskdir]

return sim_wg

end