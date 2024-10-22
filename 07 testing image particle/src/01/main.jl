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
include("$path/src_1/params.jl")

outputDir = "$path/data.lbm/src_1/"
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
    angularVelocity = angularVelocity
);

@time LBMpropagate!(model; simulationTime = simulationTime);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

sigma = viscousStressTensor(model)
writeTensor(model, sigma, "stressTensor")

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
    angularVelocity = angularVelocity
);

@time LBMpropagate!(modelClose2wall; simulationTime = simulationTime);
@time plotMassDensity(modelClose2wall);
@time plotFluidVelocity(modelClose2wall);

sigma = viscousStressTensor(modelClose2wall)
writeTensor(modelClose2wall, sigma, "stressTensor")

mv("$path/output.lbm", "$(outputDir)/R")
