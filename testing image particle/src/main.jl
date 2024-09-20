#= ==========================================================================================
=============================================================================================
preamble
=============================================================================================
========================================================================================== =#

# Environment
using Pkg; Pkg.activate(".");

# add LBMengine.jl to the environment
#= ] dev ../../LBMengine.jl =#

# packages
using LBMengine, CairoMakie, Dates, LinearAlgebra

include("src/params.jl")

outputDir = "data.lbm/movingParticle"
mkdir(outputDir)

#= ==========================================================================================
=============================================================================================
L - lejos de la pared
=============================================================================================
========================================================================================== =#

model = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    saveData = true
);
addBead!(model;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
);

@time LBMpropagate!(model; simulationTime = simulationTime, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);

mv("output.lbm", "$(outputDir)/L")

#= ==========================================================================================
=============================================================================================
R - cerca de la pared
=============================================================================================
========================================================================================== =#

modelClose2wall = modelInit(;
    x = x,
    relaxationTimeRatio = relaxationTimeRatio,
    walledDimensions = walledDimensions,
    isFluidCompressible = isFluidCompressible,
    solidNodes = solidNodes,
    saveData = true,
);
addBead!(modelClose2wall;
    massDensity = massDensity,
    radius = radius,
    position = position,
    coupleTorques = coupleTorques,
    coupleForces = coupleForces,
    angularVelocity = angularVelocity,
);

@time LBMpropagate!(modelClose2wall; simulationTime = simulationTime, verbose = true);
@time plotMassDensity(modelClose2wall);
@time plotFluidVelocity(modelClose2wall);

mv("output.lbm", "$(outputDir)/R")

#= ==========================================================================================
=============================================================================================
I - partícula imagen
=============================================================================================
========================================================================================== =#

component = 1
fig = Figure();
ax = Axis(fig[1,1], title = "x-component of velocity, t = $(modelClose2wall.time |> x -> round(x; digits = 2)), x = $(modelClose2wall.spaceTime.x[desiredXid])");
ax.xlabel = "y"; ax.ylabel = "u_x";
modelClose2wall.fluidVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, modelClose2wall.spaceTime.x, v, label = "VR");
model.fluidVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, model.spaceTime.x, v, label = "VL");
modelClose2wall.fluidVelocity[desiredXid, :] - model.fluidVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, modelClose2wall.spaceTime.x, v, label = "VR - VL = VI");
axislegend(ax, position = :rt)
save_jpg("figs/$(today())/LBM figure $(Time(now()))", fig)

#= ==========================================================================================
=============================================================================================
figs
=============================================================================================
========================================================================================== =#

#= julia> findfirst(x -> x >= 0, model.spaceTime.x) =#
#= 101 =#
desiredXid = 101

# L - lejos de la pared
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

# R - cerca de la pared
fig = Figure();
ax = Axis(fig[1,1], title = "speed, t = $(modelClose2wall.time |> x -> round(x; digits = 2)), x = $(modelClose2wall.spaceTime.x[desiredXid])");
ax.xlabel = "y"; ax.ylabel = "|u|";
modelClose2wall.fluidVelocity[desiredXid, :] .|> norm |> v -> lines!(ax, modelClose2wall.spaceTime.x, v, label = "fluid velocity");
modelClose2wall.particles[1].nodeVelocity[desiredXid, :] .|> norm |> v -> lines!(ax, modelClose2wall.spaceTime.x, v, label = "tangential velocity (particle)");
axislegend(ax, position = :rt)
save_jpg("figs/$(today())/LBM figure $(Time(now()))", fig)
component = 1
fig = Figure();
ax = Axis(fig[1,1], title = "x-component of velocity, t = $(modelClose2wall.time |> x -> round(x; digits = 2)), x = $(modelClose2wall.spaceTime.x[desiredXid])");
ax.xlabel = "y"; ax.ylabel = "u_x";
modelClose2wall.fluidVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, modelClose2wall.spaceTime.x, v, label = "fluid velocity");
modelClose2wall.particles[1].nodeVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, modelClose2wall.spaceTime.x, v, label = "tangential velocity (particle)");
axislegend(ax, position = :rt)
save_jpg("figs/$(today())/LBM figure $(Time(now()))", fig)
component = 2
fig = Figure();
ax = Axis(fig[1,1], title = "y-component of velocity, t = $(modelClose2wall.time |> x -> round(x; digits = 2)), x = $(modelClose2wall.spaceTime.x[desiredXid])");
ax.xlabel = "y"; ax.ylabel = "u_y ";
modelClose2wall.fluidVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, modelClose2wall.spaceTime.x, v, label = "fluid velocity");
modelClose2wall.particles[1].nodeVelocity[desiredXid, :] .|> (v -> v[component]) |> v -> lines!(ax, modelClose2wall.spaceTime.x, v, label = "tangential velocity (particle)");
axislegend(ax, position = :rt)
save_jpg("figs/$(today())/LBM figure $(Time(now()))", fig)
