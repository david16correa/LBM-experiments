#= this script is intended to be run using:
julia main.jl > out.out 2>&1
=#
#= ==========================================================================================
=============================================================================================
preamble
=============================================================================================
========================================================================================== =#

# directories and paths
cd(@__DIR__)  # Change working directory to the location of the script
srcPath = pwd() # save the source path
cd("../..") # change the working directory to the environment directoy
envPath = pwd() # save the environment path
cd(srcPath) # change back to the source path in order to write the output there
src_n = findall(char -> char == '/', srcPath)[end] |> id -> srcPath[id+1:end] # the src number is saved

outputDir = "$envPath/data.lbm"
run(`mkdir -p $outputDir`)

# Environment
using Pkg; Pkg.activate(envPath)

# packages
using LBMengine

# parameters
include("$srcPath/params.jl")

#= ==========================================================================================
=============================================================================================
main
=============================================================================================
========================================================================================== =#

println("initializing model..."); flush(stdout);
model = modelInit(;
    x = x,
    viscosity = viscosity,
    isFluidCompressible = isFluidCompressible,
    forceDensity = forceDensity,
    saveData = true
);
addBead!(model;
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    scheme = scheme
);

println("running simulation..."); flush(stdout);
@time LBMpropagate!(model; verbose = true, simulationTime = simulationTime, ticksBetweenSaves = ticksBetweenSaves);
#
println("plotting the mass density and fluid velocity..."); flush(stdout);
plotMassDensity(model); plotFluidVelocity(model);

println("finding stress tensor..."); flush(stdout);
@time sigma = viscousStressTensor(model)
writeTensor(model, sigma, "stressTensor")

println("moving data..."); flush(stdout);
mv("$srcPath/output.lbm", "$(outputDir)/$(src_n)")
