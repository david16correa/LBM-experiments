#= ==========================================================================================
=============================================================================================
preamble
=============================================================================================
========================================================================================== =#

# ensuring the working directory is the correct one
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
include("$path/src_4/params.jl")

outputDir = "$path/data.lbm/src_4/"
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

mv("$path/output.lbm", "$(outputDir)/R")
