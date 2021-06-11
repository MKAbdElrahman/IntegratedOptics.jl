export contour , lineplot

function contour(z::AbstractArray,grid::Grid{2},fun::Function = identity)
    x = range(grid,x̂)
    y = range(grid,ŷ)
    @gp x y fun.(z) "w image notit" "set auto fix" "set size square"
    @gp :- xlab = "x" ylab = "y" "set cblabel 'z'" palette(:dense)
    @gp :- title = "plot title "
    @gp :- xlab = "x" ylab = "y" "set size ratio -1"
  #  save(term ="pngcairo size 600,600", output ="/home/mk/heatmap2.png")
 end

 function lineplot(z::AbstractArray,grid::Grid{1},fun::Function = identity)
    x = range(grid,x̂)
    @gp  x fun.(z)  "w l tit 'lineplot'   dt 1 lw 3 lc rgb 'blue'"
 end