#= ==========================================================================================
=============================================================================================
preamble
=============================================================================================
========================================================================================== =#

# ensuring the working directory is the correct one
cd(@__DIR__)  # Change working directory to the location of the script
srcPath = pwd() # save the path of the current working directory to ensure it's always used
cd("../..") # change the working directory to the environment directoy
envPath = pwd() # save the path of the current working directory to ensure it's always used
cd(srcPath) # we return to the source path in order to save the output there

# Environment
using Pkg; Pkg.activate(envPath);

# add LBMengine.jl to the environment
#= ] dev ../../LBMengine.jl =#

# packages
using LBMengine

# parameters
include("$srcPath/params.jl")

outputDir = "$envPath/data.lbm/src_13/"
run(`mkdir -p $outputDir`)

#= ==========================================================================================
=============================================================================================
main
=============================================================================================
========================================================================================== =#

println("initializing model for swimming particle..."); flush(stdout);

model = modelInit(;
    x = x,
    viscosity = viscosity,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    collisionModel = :trt,
    saveData = true
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
    scheme = :ladd,
);

println("running simulation..."); flush(stdout);

@time LBMpropagate!(model; verbose = true, simulationTime = simulationTime, ticksBetweenSaves = ticksBetweenSaves);


println("plotting the mass density and fluid velocity..."); flush(stdout);

cd(envPath)
plotMassDensity(model); plotFluidVelocity(model);
cd(srcPath)

println("finding stress tensor..."); flush(stdout);

@time sigma = viscousStressTensor(model)
writeTensor(model, sigma, "stressTensor")

println("moving data..."); flush(stdout);

mv("$srcPath/output.lbm", "$(outputDir)/fixed")
