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
Ladd
=============================================================================================
========================================================================================== =#

outputDir = "data.lbm/ladd/movingParticle"
run(`mkdir -p $outputDir`)

#= ==========================================================================================
=============================================================================================
L - lejos de la pared
=============================================================================================
========================================================================================== =#

model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
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
    scheme = :ladd
);

@time LBMpropagate!(model; simulationTime = simulationTime, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

mv("output.lbm", "$(outputDir)/L")

#= ==========================================================================================
=============================================================================================
R - cerca de la pared
=============================================================================================
========================================================================================== =#

modelClose2wall = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    solidNodes = solidNodes,
    saveData = true,
);
addBead!(modelClose2wall;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
    scheme = :ladd
);

@time LBMpropagate!(modelClose2wall; simulationTime = simulationTime, verbose = true);
@time plotMassDensity(modelClose2wall);
@time plotFluidVelocity(modelClose2wall);

mv("output.lbm", "$(outputDir)/R")

#= ==========================================================================================
=============================================================================================
PSM
=============================================================================================
========================================================================================== =#

outputDir = "data.lbm/psm/movingParticle"
run(`mkdir -p $outputDir`)

#= ==========================================================================================
=============================================================================================
L - lejos de la pared
=============================================================================================
========================================================================================== =#

model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
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
    scheme = :psm
);

@time LBMpropagate!(model; simulationTime = simulationTime, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

mv("output.lbm", "$(outputDir)/L")

#= ==========================================================================================
=============================================================================================
R - cerca de la pared
=============================================================================================
========================================================================================== =#

modelClose2wall = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    solidNodes = solidNodes,
    saveData = true,
);
addBead!(modelClose2wall;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
    scheme = :psm
);

@time LBMpropagate!(modelClose2wall; simulationTime = simulationTime, verbose = true);
@time plotMassDensity(modelClose2wall);
@time plotFluidVelocity(modelClose2wall);

mv("output.lbm", "$(outputDir)/R")

