export contourplot
#export  lineplot

struct ContourPlot end
const  contourplot = ContourPlot()

#struct LinePlot end
#const  lineplot = LinePlot() 



function (sim::Simulation)(::ContourPlot, q::Symbol ,fun::Function = identity,
   ; xlabel = "x" , ylabel = "y", title = "contour plot ")	
   x = range(sim.grid,x̂)
   y = range(sim.grid,ŷ)
   z  = getproperty(sim,q) 
   @gp x y fun.(z) "w image notit" "set auto fix" "set size square"
   @gp :- xlab = xlabel ylab = ylabel "set cblabel 'z'" palette(:dense)
   @gp :- title = title
   @gp :- xlab = xlabel ylab = ylabel "set size ratio -1"	
end

function (sim::Simulation)(::ContourPlot, z::AbstractArray ,fun::Function = identity,
   ; xlabel = "x" , ylabel = "y", title = "contour plot ")	
   x = range(sim.grid,x̂)
   y = range(sim.grid,ŷ)
   @gp x y fun.(z) "w image notit" "set auto fix" "set size square"
   @gp :- xlab = xlabel ylab = ylabel "set cblabel 'z'" palette(:dense)
   @gp :- title = title
   @gp :- xlab = xlabel ylab = ylabel "set size ratio -1"	
end

#=
 function lineplot(z::AbstractArray,grid::Grid{1},fun::Function = identity)
    x = range(grid,x̂)
    @gp  x fun.(z)  "w l tit 'lineplot'   dt 1 lw 3 lc rgb 'blue'"
 end
=# 