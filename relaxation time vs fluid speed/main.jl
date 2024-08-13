#= ==========================================================================================
=============================================================================================

goal:
to measure the mean fluid speed for varying relaxation times; it is expected that the 
greater the relaxation time, the smaller the fluid speed, since the viscosity is linear in the
relaxation time
ν = cₛ²(τ - Δt/2).

=============================================================================================
========================================================================================== =#

# preamble
using Pkg; Pkg.activate("."); 
using LBMengine
using CairoMakie

norm(v) = sum(x for x in v.*v) |> sqrt
mean(v) = sum(v) / length(v)

gaussian(x,y) = exp(-(x^2+y^2)*5) 
len = 201;
x = range(-1, stop = 1, length = len);
u = [gaussian(i,j) * [0.1e-2; 0]  for i in x, j in x]; # |u| must be small for fluid to be incompressible! M ≈ 3u/c_s << 1
solidNodes = [
    ((-0.75 < i < -0.25) && j < 0.) || ((0.25 < i < 0.75) && j > -0.)
for i in x, j in x];

relaxationTimes = []
fluidSpeeds = []

model = modelInit(; fluidVelocity = u, x = x, walledDimensions = [2], solidNodes = solidNodes,
    relaxationTimeRatio = 0.8, # τ/Δt > 1 → under-relaxation, τ/Δt = 1 → full relaxation, 0.5 < τ/Δt < 1 → over-relaxation, τ/Δt < 0.5 → unstable
);

@time for relaxationTimeRatio in range(0.5, stop = 10, length = 50)
    @show relaxationTimeRatio
    model = modelInit(; fluidVelocity = u, x = x, walledDimensions = [2], solidNodes = solidNodes,
        relaxationTimeRatio = relaxationTimeRatio, # τ/Δt > 1 → under-relaxation, τ/Δt = 1 → full relaxation, 0.5 < τ/Δt < 1 → over-relaxation, τ/Δt < 0.5 → unstable
    );
    LBMpropagate!(model; simulationTime = 5, verbose = true);
    model.fluidVelocity .|> norm |> mean |> normU -> append!(fluidSpeeds, [normU]);
    append!(relaxationTimes, [relaxationTimeRatio]);
end

fluidSpeeds
relaxationTimes

lines(relaxationTimes, fluidSpeeds, axis = (xlabel = "τ/Δt", ylabel = "average fluid speed",))
lines(relaxationTimes .|> τ -> model.fluidParams.c2_s * model.spaceTime.Δt * (τ - 1/2), fluidSpeeds, axis = (xlabel = "viscosity", ylabel = "average fluid speed",))
lines(relaxationTimes .|> τ -> model.fluidParams.c2_s * model.spaceTime.Δt * (τ - 1/2), fluidSpeeds .|> u -> u/model.fluidParams.c_s, axis = (xlabel = "viscosity", ylabel = "average Mach number",))
