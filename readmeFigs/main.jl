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

len = 100;
x = range(-1, stop = 1, length = len);
solidNodes = [
    #= ((-0.75 < i < -0.25) && j < 0.75) || ((0.25 < i < 0.75) && j > -0.75) # big walls =#
    #= ((-0.75 < i < -0.25) && j < 0.) || ((0.25 < i < 0.75) && j > -0.) # small walls =#
    ((i + 0.3)^2 + j^2) < 0.2^2 # circular obstruction
for i in x, j in x];

model = modelInit(; 
    x = x,
    Δt = :default, # default: Δt = Δx
    relaxationTimeRatio = 0.8, # τ/Δt > 1 → under-relaxation, τ/Δt = 1 → full relaxation, 0.5 < τ/Δt < 1 → over-relaxation, τ/Δt < 0.5 → unstable
    walledDimensions = [2],
    solidNodes = solidNodes,
    forceDensity = [1.0e-3, 0.0],
    isFluidCompressible = true,
    forcingScheme = :guo # {:guo, :shan}
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

