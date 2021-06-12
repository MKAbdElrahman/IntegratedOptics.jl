export eigensolve
"""
    eigensolve(dev::Device{2}; direction::Direction,center::Tuple , k::Real)

solves the eigenvalue problem across the line noraml to `direction` and centered at `center`.  

The method was created to be used for defining mode sources for 2D problems.
"""
function eigensolve(dev::Device{2}; direction::Direction,center::Tuple , k::Real)
    ϵᵣ11 = dev.ϵᵣ11
    ix, iy = coord2index(dev.grid, center) 

    if direction == x̂ 
        Ny = size(dev.grid, ŷ)
        dy = spacing(dev.grid,ŷ)  
        Db , Df = ∂(NeumannNeumann(),Ny,dy)
        @views  ϵᵣ  =  ϵᵣ11[ix,:]
    end
    if direction == ŷ 
        Nx = size(dev.grid, x̂)
        dx = spacing(dev.grid,x̂)  
        Db , Df = ∂(NeumannNeumann(),Nx,dx)
        @views ϵᵣ  = ϵᵣ11[:,iy]
    end

    Mϵr = spdiagm(0=> ϵᵣ)

    A = k^2 .* Mϵr + Db * Df  ## Ez polarization

    eigs(A, which = :LR)

end