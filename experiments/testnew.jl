using Photon

sim = Simulation(grid = Grid(extent = (2,2), spacing = (.01,.01)))

sim(setsrc!,PlaneWave(k̂ = (3, 7), ê = (1,0,1) , a = 1))
sim(setTFSF! ,.6)
sim(setpml!,.5)
sim(setϵᵣ!,x̂,x ->5, x -> (x[1]-1)^2 + (x[2]-1)^2 <= .15 )

sim(contourplot, :src_x, imag ; xlabel = "x-axis", ylabel = "y-axis", title = "Hello")
sim(contourplot, :ϵᵣ_xx, real ; xlabel = "x-axis", ylabel = "y-axis", title = "ϵᵣ")

