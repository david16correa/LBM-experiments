#= ==========================================================================================
=============================================================================================

goal:

to verify the engine recreates Couette flow under the right conditions
https://en.wikipedia.org/wiki/Couette_flow

=============================================================================================
========================================================================================== =#

# preamble
using Pkg; Pkg.activate("."); 
using LBMengine
using CairoMakie
using Dates

norm(V) = sum(el for el in V.*V) |> sqrt

x = range(-1, stop = 1, length = 101);
solidNodes = [-0.5 > j || j > 0.5 for i in x, j in x];
solidNodeVelocity = [j > 0.5 ? [0.01, 0] : [0., 0] for i in x, j in x];

model = modelInit(; 
    x = x,
    relaxationTimeRatio = 2.6,
    solidNodes = solidNodes,
    solidNodeVelocity = solidNodeVelocity,
    isFluidCompressible = false,
);

@time LBMpropagate!(model; simulationTime = 30, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);
fig = Figure();
ax = Axis(fig[1,1], title = "fluid speed, t = $(model.time[end] |> x -> round(x; digits = 2)), x = $(model.spaceTime.x[51])");
ax.xlabel = "y"; ax.ylabel = "|u|";
model.fluidVelocity[51, :] .|> norm |> v -> lines!(ax, model.spaceTime.x, v);
save_jpg("figs/$(today())/LBM figure $(Time(now()))", fig)

