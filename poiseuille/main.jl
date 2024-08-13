#= ==========================================================================================
=============================================================================================

goal:
to verify the engine recreates Poiseuille flow under the right conditions

=============================================================================================
========================================================================================== =#

# preamble
using Pkg; Pkg.activate("."); 
using LBMengine
using CairoMakie

len = 100;
x = range(-1, stop = 1, length = len);
solidNodes = [
    -0.5 > j || j > 0.5
for i in x, j in x];

model = modelInit(; 
    x = x,
    Δt = :default, # default: Δt = Δx
    relaxationTimeRatio = 2.6, # τ/Δt > 1 → under-relaxation, τ/Δt = 1 → full relaxation, 0.5 < τ/Δt < 1 → over-relaxation, τ/Δt < 0.5 → unstable
    walledDimensions = [2],
    solidNodes = solidNodes,
    forceDensity = [0.5e-3, 0.0],
    isFluidCompressible = false,
    forcingScheme = :guo # {:guo, :shan}, default: Guo, C. Zheng, B. Shi, Phys. Rev. E 65, 46308 (2002)
);

@time LBMpropagate!(model; simulationTime = 5, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

fig = Figure();
ax = Axis(fig[1,1], title = "fluid speed, t = $(model.time[end] |> x -> round(x; digits = 2)), x = $(model.spaceTime.x[50])");
ax.xlabel = "y"; ax.ylabel = "|u|";
model.fluidVelocity[50, :] .|> norm |> v -> lines!(ax, model.spaceTime.x, v);
fig
