#= ==========================================================================================
=============================================================================================

goal:

visualize the magnus effect

=============================================================================================
========================================================================================== =#

# preamble
using Pkg; Pkg.activate("."); 
using LBMengine

x = range(-1, stop = 1, length = 201);
unitφ(x,y) = (x == y == 0) ? ([0.; 0]) : [-y; x] ./ sqrt(x^2 + y^2)
solidNodes = [(i^2 + j^2) < 0.2^2 for i in x, j in x];
solidNodeVelocity = [(i^2 + j^2) < 0.2^2 ? unitφ(i,j) * 0.05  : [0., 0] for i in x, j in x];

model = modelInit(; 
    x = x,
    relaxationTimeRatio = 2.6,
    walledDimensions = [2],
    solidNodes = solidNodes,
    solidNodeVelocity = solidNodeVelocity,
    forceDensity = [0.5e-2, 0.0],
    isFluidCompressible = true,
);

@time LBMpropagate!(model; simulationTime = 10, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);
