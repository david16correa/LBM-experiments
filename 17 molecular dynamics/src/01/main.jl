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
    viscosity = viscosity,
    dims = dims,
    saveData = true
);
addBead!(model;
    radius = radii[1],
    position = positions[1],
    coupleForces = true,
    coupleTorques = false,
);
addBead!(model;
    radius = radii[2],
    position = positions[2],
    coupleForces = true,
    coupleTorques = false,
);
addSquirmer!(model;
    radius = radii[3],
    position = positions[3],
    swimmingSpeed = swimmingSpeed,
    beta = beta,
    swimmingDirection = swimmingDirection,
    coupleForces = true,
    coupleTorques = false,
);
addLinearBond!(model,1,2; hookConstant = hookConstant)
addLinearBond!(model,2,3; hookConstant = hookConstant)

println("running simulation..."); flush(stdout);
@time LBMpropagate!(model; verbose = true, simulationTime = simulationTime, ticksSaved = ticksSaved);
#
println("plotting the mass density and fluid velocity..."); flush(stdout);
plotMassDensity(model); plotFluidVelocity(model);

println("moving data..."); flush(stdout);
mv("$srcPath/output.lbm", "$(outputDir)/$(src_n)")
