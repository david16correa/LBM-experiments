
#= ==========================================================================================
=============================================================================================

goal:

1.  find the average fluid speed as a function of time for several values of τ starting from poiseuille flow.
    It is expected that $|u|$ will decay exponentially towards some $u_\mathrm{eq}$:
    $$
        |u|(t) = A \mathrm{exp}(-\alpha t) + B
    $$

2.  α must be found as function of τ

3.  this should be repeated with varying force densities

=============================================================================================
========================================================================================== =#

# preamble
using Pkg; Pkg.activate("."); 
using LBMengine
using CairoMakie
using DelimitedFiles
using Dates

norm(v) = v.*v |> sum |> sqrt
mean(v) = sum(v)/length(v)

# 0.  create poiseuille flow initial conditions

len = 100;
x = range(-1, stop = 1, length = len);
solidNodes = [
    -0.5 > j || j > 0.5
for i in x, j in x];

initialModel = modelInit(;
    x = x,
    Δt = :default, # default: Δt = Δx
    relaxationTimeRatio = 2.6, # τ/Δt > 1 → under-relaxation, τ/Δt = 1 → full relaxation, 0.5 < τ/Δt < 1 → over-relaxation, τ/Δt < 0.5 → unstable
    walledDimensions = [2],
    solidNodes = solidNodes,
    forceDensity = [2.0e-3, 0.0],
    isFluidCompressible = false,
    forcingScheme = :guo # {:guo, :shan}, default: Guo, C. Zheng, B. Shi, Phys. Rev. E 65, 46308 (2002)
);
@time LBMpropagate!(initialModel; simulationTime = 5, verbose = true);

initialModel = modelInit(;
    x = x,
    massDensity = initialModel.massDensity, # default: ρ(x) = 1
    fluidVelocity = initialModel.fluidVelocity, # default: u(x) = 0
    relaxationTimeRatio = 0.8, # τ/Δt > 1 → under-relaxation, τ/Δt = 1 → full relaxation, 0.5 < τ/Δt < 1 → over-relaxation, τ/Δt < 0.5 → unstable
    walledDimensions = [2], # walls around y axis (all non-walled dimensions are periodic!)
    solidNodes = solidNodes,
    isFluidCompressible = false,
);

# 1.  find the average fluid speed as a function of time for several values of τ starting from poiseuille flow.

simulationTime = 60
time = range(initialModel.spaceTime.Δt, stop = simulationTime, step = initialModel.spaceTime.Δt) |> collect;
τs = range(0.6, stop = 10, length = 100)
Fs = range(0.0, stop = 2.0e-3, length = 5)

#= for F in Fs[2:3] =#
for F in Fs[4:5]
    dirName = "F = $(F)"
    mkdir("exponential decay to equilibrium/outputData/$(dirName)")
    @time for τ in τs
        print("\r τ = $(τ)")
        model = modelInit(;
            x = x,
            massDensity = initialModel.massDensity, # default: ρ(x) = 1
            fluidVelocity = initialModel.fluidVelocity, # default: u(x) = 0
            relaxationTimeRatio = τ, # τ/Δt > 1 → under-relaxation, τ/Δt = 1 → full relaxation, 0.5 < τ/Δt < 1 → over-relaxation, τ/Δt < 0.5 → unstable
            walledDimensions = [2], # walls around y axis (all non-walled dimensions are periodic!)
            solidNodes = solidNodes,
            forceDensity = [F, 0.0],
            isFluidCompressible = false,
        );
        us = [] |> Array{Float64}
        for t in time |> eachindex
            tick!(model);
            model.fluidVelocity .|> norm |> mean |> u -> append!(us, [u])
        end
        open("exponential decay to equilibrium/outputData/$(dirName)/relaxationTimeRatio $(τ).csv", "w") do io
            writedlm(io, [time us], ',')
        end;
    end
end

# 2. α must be found as function of τ

# plotting some results
for fId in 1:4, id in [1; 3; 5; 10:10:100]
    τs[id]
    F = Fs[fId]
    dirName = "F = $(F)"
    M = readdlm("exponential decay to equilibrium/outputData/$(dirName)/relaxationTimeRatio $(τs[id]).csv", ',');
    fig = Figure();
    ax = Axis(fig[1,1], title = "fluid speed, τ/Δt = $(τs[id])");
    ax.xlabel = "t"; ax.ylabel = "|u|";
    ylims!(ax,0, 0.004);
    lines!(ax, M)
    save("figs/$(today())/speedVsTau/F = $(F) id $(id).png", fig)
end


