# Environment
using Pkg;
Pkg.activate("environment"); 
using LBMengine

len = 100;
x = range(-1, stop = 1, length = len);
solidNodes = [
    #= ((-0.75 < i < -0.25) && j < 0.75) || ((0.25 < i < 0.75) && j > -0.75) # paredes grandes =#
    #= ((i + 0.3)^2 + j^2) < 0.2^2 # esfera =#
    ((-0.75 < i < -0.25) && j < 0.) || ((0.25 < i < 0.75) && j > -0.) # paredes chicas
for i in x, j in x];

model = modelInit(; 
    x = x,
    Δt = :default, # default: Δt = Δx
    #=relaxationTimeRatio = 0.8, # incompressible=#
    relaxationTimeRatio = 3.1, # compressible
    walledDimensions = [2],
    solidNodes = solidNodes,
    #=forceDensity = [0.5e-1, 0.0],=#
    forceDensity = [0.5e-2, 0.0],
    isFluidCompressible = false,
    forcingScheme = :guo # {:guo, :shan}
);

@time LBMpropagate!(model; simulationTime = 5, verbose = true);
@time plotMassDensity(model);
@time plotFluidVelocity(model);
#=@time plotMomentumDensity(model);=#
#=model.fluidParams.c2_s * (model.fluidParams.relaxationTime - model.spaceTime.Δt/2) # Viscosity=#
model.fluidVelocity / model.fluidParams.c_s .|> norm |> maximum # Mach Number
model.schemes

@time anim8massDensity(model);
@time anim8fluidVelocity(model);
#= @time anim8momentumDensity(model); =#

fig = Figure();
ax = Axis(fig[1,1], title = "fluid speed, t = $(model.time[end] |> x -> round(x; digits = 2)), y = $(model.spaceTime.x[50])");
ax.xlabel = "y"; ax.ylabel = "|u|";
model.fluidVelocity[:, 50] .|> norm |> v -> lines!(ax, model.spaceTime.x, v);
fig
