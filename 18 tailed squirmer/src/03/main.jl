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
    viscosity = viscosity,
    dims = dims,
    saveData = true
);
for x in xs[1:end-1]
    addBead!(model;
        radius = radius,
        position = [x, rand()*1e-1], # particles are initially placed with slightly varying y-coordinates
        coupleForces = coupleForces,
        coupleTorques = coupleTorques,
    );
end
addSquirmer!(model;
    radius = radius,
    position = [xs[end], rand()*1e-1], # particles are initially placed with slightly varying y-coordinates
    swimmingSpeed = swimmingSpeed,
    beta = beta,
    swimmingDirection = swimmingDirection,
    coupleForces = coupleForces,
    coupleTorques = coupleTorques,
);
for pair in bondPairs
    addLinearBond!(model, pair...; stiffness=stiffness)
end
#
addWCA!(model)

println("running simulation..."); flush(stdout);
@time LBMpropagate!(model; verbose = true, simulationTime = simulationTime, ticksSaved = ticksSaved);
#
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
