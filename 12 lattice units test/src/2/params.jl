#= ==========================================================================================
=============================================================================================
params - larger sphere
=============================================================================================
========================================================================================== =#

# space
xmax = 6
x_space = range(-xmax, stop = xmax, step = 0.01);
x = 1:length(x_space)
walledDimensions = [1, 2];

# fluid
relaxationTimeRatio = 0.50000267;
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³
# → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 μ m²/s,
# in LBM ν = cₛ²(τ - Δt/2), so for water τ/Δt = 0.50000267

isFluidCompressible = false;

# particle
massDensity = 1.;
radius = 0.4/step(x_space)*step(x);
position = [xmax, 0.6]/step(x_space)*step(x);
coupleTorques = false;
coupleForces = false;
angularVelocity = 0.01*step(x_space)/step(x);

# simulation
simulationTime = 60 * step(x)/step(x_space);
ticksBetweenSaves = 100;
