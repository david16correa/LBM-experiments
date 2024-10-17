#= ==========================================================================================
=============================================================================================
preamble
=============================================================================================
========================================================================================== =#

# ensuring the working directory is the correct one
cd(@__DIR__)  # Change working directory to the location of the script
cd("../..") # change the working directory to the correct one
path = pwd() # save the path of the current working directory to ensure it's always used

# environment
using Pkg; Pkg.activate(path);

# add LBMengine.jl to the environment
#= ] dev ../../LBMengine.jl =#

# packages
using LBMengine

# parameters
include("$path/src/1/params.jl")

# directory for our output
outputDir = "$path/data.lbm/src_1"
run(`mkdir -p $outputDir`)

#= ==========================================================================================
=============================================================================================
main
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
    angularVelocity = angularVelocity,
);

println("model initialized!"); flush(stdout);

@time LBMpropagate!(model; verbose = true, simulationTime = simulationTime, ticksBetweenSaves = ticksBetweenSaves);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

println("finding stress tensor..."); flush(stdout);

@time sigma = viscousStressTensor(model)
writeTensor(model, sigma, "stressTensor")

println("stress tensor found!"); flush(stdout);

mv("$path/output.lbm", "$(outputDir)/output")
