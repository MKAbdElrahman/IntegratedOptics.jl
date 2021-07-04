export overlap

function overlap end
function (opt::Optimization)(::typeof(overlap))
   sum(opt.∂L∂x .* opt.x)
end
