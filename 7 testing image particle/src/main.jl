#= ==========================================================================================
=============================================================================================
preamble
=============================================================================================
========================================================================================== =#

# ensuring the working directory is "10 rotating sphere in a box"
cd(@__DIR__)  # Change working directory to the location of the script
cd("..") # change the working directory to its parent directoyry
path = pwd() # save the path of the current working directory to ensure it's always used

# Environment
using Pkg; Pkg.activate(path);

# add LBMengine.jl to the environment
#= ] dev ../../LBMengine.jl =#

# packages
using LBMengine

# parameters
include("$path/src/params.jl")

#= ==========================================================================================
=============================================================================================
Ladd
=============================================================================================
========================================================================================== =#

outputDir = "$path/data.lbm/ladd/movingParticle"
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

mv("$path/output.lbm", "$(outputDir)/L")

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

mv("$path/output.lbm", "$(outputDir)/R")

#= ==========================================================================================
=============================================================================================
PSM
=============================================================================================
========================================================================================== =#

outputDir = "$path/data.lbm/psm/movingParticle"
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

mv("$path/output.lbm", "$(outputDir)/L")

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

mv("$path/output.lbm", "$(outputDir)/R")

