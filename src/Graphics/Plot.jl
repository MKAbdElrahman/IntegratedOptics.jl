export contourplot
export  lineplot

struct ContourPlot end
const  contourplot = ContourPlot()

struct LinePlot end
const  lineplot = LinePlot() 



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


function (sim::Simulation)(::ContourPlot, q::Symbol , dir::Direction, fun::Function = identity,
   ; xlabel = "x" , ylabel = "y", title = "contour plot ")	
   x = range(sim.grid,x̂)
   y = range(sim.grid,ŷ)
   z  = sim(q,dir)
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

function (sim::Simulation)(::LinePlot, z::AbstractArray ,fun::Function = identity,
    ; xlabel = "x", title = "line plot ")
    x = range(sim.grid,x̂)
    @gp  x fun.(z)  "w l tit 'lineplot'   dt 1 lw 3 lc rgb 'blue'"  "set auto fix"
end

function (sim::Simulation)(::LinePlot, q::Symbol ,fun::Function = identity,
   ; xlabel = "x" , title = "contour plot ")	
   x = range(sim.grid,x̂)
   z  = getproperty(sim,q) 
   @gp  x fun.(z)  "w l tit 'lineplot'   dt 1 lw 3 lc rgb 'blue'"  "set auto fix"
end
