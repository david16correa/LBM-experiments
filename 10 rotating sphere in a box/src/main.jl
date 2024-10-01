#= ==========================================================================================
=============================================================================================
preamble
=============================================================================================
========================================================================================== =#

# ensuring the working directory is "10 rotating sphere in a box"
cd(@__DIR__)  # Change working directory to the location of the script
cd("..") # change the working directory to its parent directoyry
path = pwd() # save the path of the current working directory to ensure it's always used

# environment
using Pkg; Pkg.activate(path);

# add LBMengine.jl to the environment
#= ] dev ../../LBMengine.jl =#

# packages
using LBMengine

# parameters
include("$path/src/params.jl")

# directory for our output
outputDir = "$path/data.lbm"
run(`mkdir -p $outputDir`)

#= ==========================================================================================
=============================================================================================
1.- h = 0.1
=============================================================================================
========================================================================================== =#

model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    solidNodes = solidNodes_1,
    saveData = true,
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
);

@time LBMpropagate!(model; simulationTime = simulationTime, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

mv("$path/output.lbm", "$(outputDir)/0.1")

#= ==========================================================================================
=============================================================================================
2.- h = 0.25
=============================================================================================
========================================================================================== =#


model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    solidNodes = solidNodes_2,
    saveData = true,
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
);

@time LBMpropagate!(model; simulationTime = simulationTime);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

mv("$path/output.lbm", "$(outputDir)/0.2")

#= ==========================================================================================
=============================================================================================
3.- h = 0.5
=============================================================================================
========================================================================================== =#


model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    solidNodes = solidNodes_3,
    saveData = true,
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
);

@time LBMpropagate!(model; simulationTime = simulationTime);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

mv("$path/output.lbm", "$(outputDir)/0.5")

#= ==========================================================================================
=============================================================================================
4.- h = 0.75
=============================================================================================
========================================================================================== =#


model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    solidNodes = solidNodes_4,
    saveData = true,
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
);

@time LBMpropagate!(model; simulationTime = simulationTime);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

mv("$path/output.lbm", "$(outputDir)/0.75")
