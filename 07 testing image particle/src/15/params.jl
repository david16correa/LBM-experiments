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
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (μm)²/(ms),
viscosity = 0.890 # (μm)²/(μs)
isFluidCompressible = false;

# particle
massDensity = 1.; # water density units
radius = 1.0; # μm
position = [0, 1.5-xmax]; # μm
coupleTorques = false;
coupleForces = false;
angularVelocity = 1e-6; # rad/μs

# simulation
simulationTime = 20e3; # μs → 0.02 s = 20 ms
ticksBetweenSaves = 2e3; # ticksBetweenSaves = 2,000, 0.1 μs per tick → 0.2 ms between saves → 100 ticks saved
