#= ==========================================================================================
=============================================================================================

goal:

1.  find the average fluid speed as a function of time for several values of τ starting from poiseuille flow.
    It is expected that $|u|$ will decay exponentially towards some $u_\mathrm{eq}$:
    $$
        |u|(t) = A \mathrm{exp}(-\alpha t) + B
    $$

2.  α must be found as function of τ

Note: this should be repeated with varying force densities!

=============================================================================================
========================================================================================== =#

# preamble
using Pkg; Pkg.activate("."); 
using LBMengine
using CairoMakie
using DelimitedFiles
using Dates
using LsqFit

norm(v) = v.*v |> sum |> sqrt
mean(v) = sum(v)/length(v)

# 0.  prepare poiseuille flow initial conditions

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

# warning: this step took 35+ hours to run! Run this at your own peril!
for F in Fs
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

# defining the model
@. exponentialModel(x, p) = p[1] * exp(-x * p[2]) + p[3];
p0 = [0.5, 0.5, 0.5];

# fitting the data and saving α vs τ
c = 1
for fId in eachindex(Fs)
    αs = [];
    F = Fs[fId];
    for id in eachindex(τs)
        τ = τs[id]; dirName = "F = $(F)"
        M = readdlm("exponential decay to equilibrium/outputData/F = $(F)/relaxationTimeRatio $(τs[id]).csv", ',');
        t, u = M |> eachrow |> rows -> ([m[1] for m in rows], [m[2] for m in rows]);
        fit = curve_fit(exponentialModel, t, u, p0)
        append!(αs, fit.param[2])
    end
    open("exponential decay to equilibrium/outputData/alphaVsTau - F = $(F).csv", "w") do io
        writedlm(io, [τs αs], ',')
    end;
end

# plotting the results; finding the linear fit
@. linearModel(x, p) = p[1] * x + p[2];
p0 = [0.5, 0.5];
fig = Figure();
ax = Axis(fig[1:5,1:5], xticks = 1:10, title = "u̅(t) = A exp(-αt) + B; finding α as a function of τ.");
ax.xlabel = "τ"; ax.ylabel = "α";
ylims!(ax,0, 0.6);
for fId in eachindex(Fs)[end:-1:1]
    F = Fs[fId];
    M = readdlm("exponential decay to equilibrium/outputData/alphaVsTau - F = $(F).csv", ',')
    τ, α = M |> eachrow |> rows -> ([m[1] for m in rows], [m[2] for m in rows]);
    fit = curve_fit(linearModel, τ, α, p0)
    lines!(ax, M, label = "|F| = $(F), m = $(fit.param[1] |> x -> round(x, digits = 2))")
end
axislegend(ax, position = :rb)
save("figs/$(today())/alphaVsTau $(Time(now())).png", fig)
