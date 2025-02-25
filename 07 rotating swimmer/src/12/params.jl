#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 15 # μm
x = range(-xmax, stop = xmax, step = 0.05);
walledDimensions = [1,2];

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (μm)²/(ms),
viscosity = 890 # (μm)²/(ms)
isFluidCompressible = false;

# particle
massDensity = 1.; # water density units
radius = 1.0; # μm
position = [0, 1.5-xmax]; # μm
coupleTorques = false;
coupleForces = true;
angularVelocity = 1e-3; # rad/ms

# simulation
simulationTime = 50; # ms → 0.1 s
ticksBetweenSaves = 10; # ticksBetweenSaves = 10, 0.1 ms per tick → 1 ms between saves → 100 ticks saved
