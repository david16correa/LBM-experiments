#= ==========================================================================================
=============================================================================================

goal:
que esta cosa jale pofavo

=============================================================================================
========================================================================================== =#

# Environment
using Pkg; Pkg.activate(".");
using LBMengine, CairoMakie
using Dates, LinearAlgebra

x = range(-1, stop = 1, length = 101);
solidNodes = [-0.9 > i || i > 0.9 || -0.9 > j || j > 0.9 for i in x, j in x];

model = modelInit(;
    x = x,
    #= massDensity = [length(x) for _ in 1:2] |> v -> ones(v...) |> M -> 1.5*M, =#
    relaxationTimeRatio = 0.9,
    walledDimensions = [1, 2],
    #= forceDensity = [0.5e-2, 0.0], =#
    solidNodes = solidNodes,
    #= solidNodeVelocity = solidNodeVelocity, =#
    saveData = false
);
addBead!(model;
    massDensity = 2.e-0,
    radio = 0.3,
    position = [-0., -0.5],
    #= radio = 0.2, =#
    #= position = [-0., -0.], =#
    coupleTorques = false,
    coupleForces = true,
    angularVelocity = 0.05,
    #= velocity = [.0, 0] =#
);

@time LBMpropagate!(model; ticks = 10, verbose = true);
@time plotFluidVelocity(model);

@time LBMpropagate!(model; simulationTime = 31, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

fig, ax, hm = model.particles[1].nodeVelocity |> M -> [m[1] for m in M] |> M -> heatmap(M, axis = (aspect = 1, )); Colorbar(fig[:, end+1], hm); fig

desiredXid = 101
fig = Figure();
ax = Axis(fig[1,1], title = "speed, t = $(model.time |> x -> round(x; digits = 2)), x = $(model.spaceTime.x[desiredXid])");
ax.xlabel = "y"; ax.ylabel = "|u|";
model.fluidVelocity[desiredXid, :] .|> norm |> v -> lines!(ax, model.spaceTime.x, v, label = "fluid velocity");
model.particles[1].nodeVelocity[desiredXid, :] .|> norm |> v -> lines!(ax, model.spaceTime.x, v, label = "tangential velocity (particle)");
axislegend(ax, position = :rt)
save_jpg("figs/$(today())/LBM figure $(Time(now()))", fig)
component = 1
fig = Figure();
ax = Axis(fig[1,1], title = "x-component of velocity, t = $(model.time |> x -> round(x; digits = 2)), x = $(model.spaceTime.x[desiredXid])");
ax.xlabel = "y"; ax.ylabel = "u_x";
model.fluidVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, model.spaceTime.x, v, label = "fluid velocity");
model.particles[1].nodeVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, model.spaceTime.x, v, label = "tangential velocity (particle)");
axislegend(ax, position = :rt)
save_jpg("figs/$(today())/LBM figure $(Time(now()))", fig)
component = 2
fig = Figure();
ax = Axis(fig[1,1], title = "y-component of velocity, t = $(model.time |> x -> round(x; digits = 2)), x = $(model.spaceTime.x[desiredXid])");
ax.xlabel = "y"; ax.ylabel = "u_y ";
model.fluidVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, model.spaceTime.x, v, label = "fluid velocity");
model.particles[1].nodeVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, model.spaceTime.x, v, label = "tangential velocity (particle)");
axislegend(ax, position = :rt)
save_jpg("figs/$(today())/LBM figure $(Time(now()))", fig)


x = range(-2, stop = 2, length = 200);

solidNodes = [j < -0.5 for i in x, j in x];

model = modelInit(;
    x = x,
    relaxationTimeRatio = 1.1,
    walledDimensions = [2],
    isFluidCompressible = true,
    saveData = false,
    solidNodes = solidNodes
);
addBead!(model;
    massDensity = 1.5e-0,
    radius = 0.2,
    position = [-0., -.0],
    coupleTorques = false,
    coupleForces = true,
    angularVelocity = 0.05,
    #= velocity = [.0, 0] =#
);
