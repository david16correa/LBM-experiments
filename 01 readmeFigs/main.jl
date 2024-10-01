#= ==========================================================================================
=============================================================================================

goal:

to generate some nice figures for the repos

=============================================================================================
========================================================================================== =#

# preamble
using Pkg; Pkg.activate("."); 
using LBMengine
norm(V) = sum(el for el in V.*V) |> sqrt

x = range(-1, stop = 1, length = 101);
solidNodes = [
    #= ((-0.75 < i < -0.25) && j < 0.75) || ((0.25 < i < 0.75) && j > -0.75) # big walls =#
    #= ((-0.75 < i < -0.25) && j < 0.) || ((0.25 < i < 0.75) && j > -0.) # small walls =#
    ((i + 0.3)^2 + j^2) < 0.2^2 # circular obstruction
for i in x, j in x];

model = modelInit(; 
    x = x,
    relaxationTimeRatio = 0.8, # τ/Δt
    walledDimensions = [2],
    solidNodes = solidNodes,
    forceDensity = [1.0e-3, 0.0],
    isFluidCompressible = true,
);

@time LBMpropagate!(model; simulationTime = 15, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);
#=@time plotMomentumDensity(model);=#
model.fluidVelocity / model.fluidParams.c_s .|> norm |> maximum # Mach Number
model.schemes

@time anim8massDensity(model; verbose = true);
@time anim8fluidVelocity(model; verbose = true);
#=@time anim8momentumDensity(model);=#

