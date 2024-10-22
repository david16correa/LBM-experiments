#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 15 # μm
x = range(-xmax, stop = xmax, step = 0.1);
walledDimensions = [1,2];

# fluid
relaxationTimeRatio = 267
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³
# → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 890 (μm)²/(ms),
# in LBM ν = cₛ²(τ - Δt/2), so for water τ/Δt = 267 ms

isFluidCompressible = false;

# particle
massDensity = 1.;
radius = 1.0;
position = [0, 1.5-xmax];
coupleTorques = false;
coupleForces = false;
angularVelocity = 0.001; # 1/ms

# simulation
simulationTime = 1e4; # ms → 100 s
ticksBetweenSaves = 1e3;
