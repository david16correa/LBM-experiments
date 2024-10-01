#= ==========================================================================================
=============================================================================================
preamble
=============================================================================================
========================================================================================== =#

# Environment
using Pkg; Pkg.activate(".");

# add LBMengine.jl to the environment
#= ] dev ../../LBMengine.jl =#

# packages
using LBMengine

include("src/params.jl")

n += 1
outputDir = "data.lbm/attempt $(n)"
run(`mkdir -p $outputDir`)

#= ==========================================================================================
=============================================================================================
Ladd
=============================================================================================
========================================================================================== =#

model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    solidNodes = solidNodes,
    solidNodeVelocity = solidNodeVelocity,
    saveData = true,
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
    scheme = :ladd
);

@time LBMpropagate!(model; simulationTime = simulationTime, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

mv("output.lbm", "$(outputDir)/ladd")

#= ==========================================================================================
=============================================================================================
PSM
=============================================================================================
========================================================================================== =#


model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    solidNodes = solidNodes,
    solidNodeVelocity = solidNodeVelocity,
    saveData = true,
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
    scheme = :psm
);

@time LBMpropagate!(model; simulationTime = 2simulationTime, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

mv("output.lbm", "$(outputDir)/psm")
