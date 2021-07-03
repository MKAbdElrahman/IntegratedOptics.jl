export Cuboid , Sphere

abstract type GeometryPrimitive end

struct Cuboid <: GeometryPrimitive
    bounds
end     
function (c::Cuboid)(x)
    prod(c.bounds[1] .<= x .<= c.bounds[2])
end
    

struct Sphere <: GeometryPrimitive
    radius
    center
end 


function (s::Sphere)(x)
    norm(x .- s.center) <= s.radius
end
    