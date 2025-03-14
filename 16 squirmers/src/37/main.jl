#= this script is intended to be run using:
    julia main.jl > out.out 2>&1 &
=#
#= ==========================================================================================
=============================================================================================
preamble
=============================================================================================
========================================================================================== =#

# directories and paths
cd(@__DIR__); srcPath = pwd() # params.jl will be read here
cd("../.."); outPath = pwd() # data output directory will be created here
cd(".."); envPath = pwd() # the environment is here
cd(srcPath) # the simulation must be run here
src_n = findall(char -> char == '/', srcPath)[end] |> id -> srcPath[id+1:end] # the src number is saved

# the output directory is created
outputDir = "$outPath/data.lbm"
run(`mkdir -p $outputDir`)

# Environment
using Pkg; Pkg.activate(envPath)

# packages
using LBMengine

# parameters and auxilary functions
include("$srcPath/params.jl")

#= ==========================================================================================
=============================================================================================
main
=============================================================================================
========================================================================================== =#

println("initializing model..."); flush(stdout);
model = modelInit(;
    xlims = xlims,
    dims = dims,
    viscosity = viscosity,
    isFluidCompressible = isFluidCompressible,
    saveData = true
);
addSquirmer!(model;
    radius = radius,
    swimmingSpeed = swimmingSpeed,
    beta = beta,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
);

println("running simulation..."); flush(stdout);
@time LBMpropagate!(model; verbose = true, simulationTime = simulationTime, ticksSaved = ticksSaved);

println("finding stress tensor..."); flush(stdout);
@time sigma = viscousStressTensor(model)
writeTensor(model, sigma, "stressTensor")

println("moving data..."); flush(stdout);
mv("$srcPath/output.lbm", "$(outputDir)/$(src_n)")
