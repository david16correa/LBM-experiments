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
include("$srcPath/aux.jl")
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
for Id in eachindex(xs)
    addBead!(model;
        radius = radius,
        position = [xs[Id], ys[Id]],
        coupleForces = coupleForces,
        coupleTorques = coupleTorques,
    );
end
for Id in eachindex(bondPairs)
    addAuxBond!(model, bondPairs[Id]...; stiffness=10, equilibriumDisplacement = equilibriumDisplacements[Id])
end
addPolarBond!(model, 1,2,3; stiffness=10) # to keep all particles aligned

println("running simulation; first stage..."); flush(stdout);
@time LBMpropagate!(model; verbose = true, simulationTime = simulationTime, ticksSaved = 2); # the system is prepared; only two ticks are saved
println("running simulation; second stage..."); flush(stdout);
@time LBMpropagate!(model; verbose = true, simulationTime = period*10, ticksSaved = ticksSaved); # ten periods are simulated, saving several ticks
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
