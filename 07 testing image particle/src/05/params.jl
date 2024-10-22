#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 6
x = range(-xmax, stop = xmax, step = 0.01);
walledDimensions = [1,2];

# fluid
relaxationTimeRatio = 0.500267
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³
# → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 μ m²/s,
# in LBM ν = cₛ²(τ - Δt/2), so for water τ/Δt = 0.500267

isFluidCompressible = false;

# particle
massDensity = 1.;
radius = 0.4;
position = [0, 0.6-xmax];
coupleTorques = false;
coupleForces = true;
angularVelocity = 0.01;

# simulation
simulationTime = 60;
ticksBetweenSaves = 100;
