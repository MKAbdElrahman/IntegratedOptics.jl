# Defining Grids

In order to initialize a simulation, you have to define a grid upon which all computations will be done.
Currently, Cartesian grids, with uniform spacing along each dimension are supported.


Grids are defined by using the `Grid` constructor which must take as input two keword arguments:

- `spacing = (dx,dy,..)`: the cell sizes for  each dimension. 
- `extent = (Lx,Ly,..)`:  the grid length for each dimension.

`spacing` and `extent` mush have the same length. 



#### Examples:
##### 1D Grid
```@example
using Photon              # hide
Lx = 15 
dx = 0.05
Grid(extent = (Lx,) , spacing = (dx,) )
```


##### 2D Grid
```@example
using Photon              # hide
Lx = 15
Ly = 7.5 
dx = 0.05
dy = 0.2
Grid(extent = (Lx,Ly) , spacing = (dx,dy) )
```


##### 3D Grid
```@example
using Photon              # hide
Lx = 15
Ly = 7.5
Lz = 4.5 
dx = 0.05
dy = 0.2
dz = 0.1
Grid(extent = (Lx,Ly,Lz) , spacing = (dx,dy,dz) )
```
