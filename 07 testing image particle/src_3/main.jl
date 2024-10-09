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
include("$path/src_3/params.jl")

outputDir = "$path/data.lbm/src_3/"
run(`mkdir -p $outputDir`)

#= ==========================================================================================
=============================================================================================
R - cerca de la pared
=============================================================================================
========================================================================================== =#

println("model is being defined"); flush(stdout);

model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    #= solidNodes = solidNodes, =#
    saveData = false,
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity
);

println("model is now defined"); flush(stdout);

@time LBMpropagate!(model; verbose = true, simulationTime = simulationTime, ticksBetweenSaves = ticksBetweenSaves);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

sigma = viscousStressTensor(model)
writeTensor(model, sigma, "stressTensor")

mv("$path/output.lbm", "$(outputDir)/R")

model.fluidVelocity |> M -> [m[1] for m in M] |> M -> heatmap(M, axis = (aspect = 1,))

model.particles[1].nodeVelocity |> M -> [m[2] for m in M] |> M -> heatmap(M, axis = (aspect = 1,))
