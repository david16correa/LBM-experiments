#= ==========================================================================================
=============================================================================================
preamble
=============================================================================================
========================================================================================== =#

# ensuring the working directory is the correct one
cd(@__DIR__)  # Change working directory to the location of the script
srcPath = pwd() # save the path of the current working directory to ensure it's always used
cd("../..") # change the working directory to the correct one
envPath = pwd() # save the path of the current working directory to ensure it's always used

# Environment
using Pkg; Pkg.activate(envPath);

# add LBMengine.jl to the environment
#= ] dev ../../LBMengine.jl =#

# packages
using LBMengine

# parameters
include("$srcPath/params.jl")

outputDir = "$envPath/data.lbm/src_5/"
run(`mkdir -p $outputDir`)

#= ==========================================================================================
=============================================================================================
R - cerca de la pared
=============================================================================================
========================================================================================== =#

println("initializing model..."); flush(stdout);

model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    saveData = true,
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity
);

println("model initialized!"); flush(stdout);

@time LBMpropagate!(model; verbose = true, simulationTime = simulationTime, ticksBetweenSaves = ticksBetweenSaves);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

println("finding stress tensor..."); flush(stdout);

sigma = viscousStressTensor(model)
writeTensor(model, sigma, "stressTensor")

println("stress tensor found!"); flush(stdout);

mv("$envPath/output.lbm", "$(outputDir)/R")
