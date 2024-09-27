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

#= ==========================================================================================
=============================================================================================
main
=============================================================================================
========================================================================================== =#

outputDir = "data.lbm"
run(`mkdir -p $outputDir`)

model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    solidNodes = solidNodes,
    solidNodeVelocity = solidNodeVelocity,
    isFluidCompressible = isFluidCompressible,
    saveData = true
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
    scheme = scheme
);

@time LBMpropagate!(model; simulationTime = simulationTime, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

mv("output.lbm", "$(outputDir)/trajectories")
