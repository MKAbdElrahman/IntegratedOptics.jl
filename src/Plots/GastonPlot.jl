export HeatMap ,saveplot , LinePlot, Axes


import Gaston: plot, heatmap , Axes , save


function saveplot end
saveoptions =  "font 'Consolas,10' size 1280,900 lw 1 background 'white'"
function (sim::Simulation)(::typeof(saveplot);term = "png",output = "./figure.png",saveopts = saveoptions)
    save(term = term , output = output,saveopts = saveopts)
end

function HeatMap end

heatmapax = Axes(auto = "fix", palette = :balance)
function (sim::Simulation)(::typeof(HeatMap), q::Symbol; apply::Function = real, axes = heatmapax, args...)	
  x = range(sim.grid,x̂) 
  y = range(sim.grid,ŷ) 
  z  = getproperty(sim,q)   
  heatmap(x,y,apply.(z)',axes; args...)	
end


function (sim::Simulation)(::typeof(HeatMap), q::Symbol ,dir::Direction; apply::Function = real , axes = heatmapax ,  args...)	
  x = range(sim.grid,x̂) 
  y = range(sim.grid,ŷ) 
  z  = sim(q,dir)
  heatmap(x,y,apply.(z)',axes; args...)	
end


function (sim::Simulation)(::typeof(HeatMap), z::AbstractArray ; apply::Function = real,axes = heatmapax, args...)	
  x = range(sim.grid,x̂) 
  y = range(sim.grid,ŷ) 
  heatmap(x,y,apply.(z)',axes; args...)	
end

function LinePlot end

function (sim::Simulation)(::typeof(LinePlot), q::Symbol; apply::Function = real, axes = Axes(auto = "fix"), args...)	
  x = range(sim.grid,x̂)
  z  = getproperty(sim,q) 
  plot(x,apply.(z),axes,w = :l ; args...)	
end

function (sim::Simulation)(::typeof(LinePlot), z::AbstractArray ; apply::Function = real,axes = Axes(auto = "fix"), args...)	
  x = range(sim.grid,x̂)
  plot(x,apply.(z),axes,w = :l ; args...)	
end

function (sim::Simulation)(::typeof(LinePlot), q::Symbol ,dir::Direction; apply::Function = real , axes = Axes(auto = "fix") ,  args...)	
  x = range(sim.grid,x̂)
  z  = sim(q,dir)
  plot(x,apply.(z),axes,w = :l ; args...)	
end

