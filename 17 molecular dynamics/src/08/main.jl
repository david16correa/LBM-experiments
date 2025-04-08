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

# parameters and auxiliarauxilaryy functions
include("$srcPath/params.jl")

#= ==========================================================================================
=============================================================================================
main
=============================================================================================
========================================================================================== =#

println("initializing model..."); flush(stdout);
model = modelInit(;
    xlims = xlims,
    walledDimensions = walledDimensions,
    viscosity = viscosity,
    dims = dims,
    saveData = true
);
addBead!(model;
    radius = radius,
    position = positions[1],
    coupleForces = coupleForces,
    coupleTorques = coupleTorques,
);
addBead!(model;
    radius = radius,
    position = positions[2],
    coupleForces = coupleForces,
    coupleTorques = coupleTorques,
);
addBistableBond!(model,1,2; height = height, lowDisp = lowDisp)
addLinearBond!(model,1,2; hookConstant = hookConstant, equilibriumDisp = equilibriumDisp)
addDipoles!(model,1,2; magneticField = magneticField)

println("running simulation..."); flush(stdout);
@time LBMpropagate!(model; verbose = true, simulationTime = simulationTime, ticksSaved = ticksSaved);

println("plotting the mass density and fluid velocity..."); flush(stdout);
try
    plotMassDensity(model);
catch
    println("plotMassDensity() failed!")
end
try
    plotFluidVelocity(model);
catch
    println("plotFluidVelocity() failed!")
end

println("moving data..."); flush(stdout);
mv("$srcPath/output.lbm", "$(outputDir)/$(src_n)")
