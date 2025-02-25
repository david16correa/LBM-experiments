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
relaxationTimeRatio = 27.2
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³
# → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (μm)²/(μs),
# in LBM ν = cₛ²(τ - Δt/2), so for water τ/Δt = 27.12

isFluidCompressible = false;

# particle
massDensity = 1.;
radius = 1.0;
position = [0, 1.5-xmax];
coupleTorques = false;
coupleForces = false;
angularVelocity = 1e-6; # 1/μs

# simulation
simulationTime = 1e4; # μs → 0.01 s
ticksBetweenSaves = 1e3;
