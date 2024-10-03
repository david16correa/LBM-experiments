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
main
=============================================================================================
========================================================================================== =#

model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    solidNodes = solidNodes,
    saveData = true,
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = false,
    coupleForces = false,
    angularVelocity = angularVelocity,
);

@time LBMpropagate!(model; simulationTime = simulationTime);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

sigma = viscousStressTensor(model)
writeTensor(model, sigma, "stressTensor")

mv("$path/output.lbm", "$(outputDir)/fixedParticle_finer")
