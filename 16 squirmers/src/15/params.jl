#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-50, 50); # μm

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (μm)²/(μs),
viscosity = 0.890 # (μm)²/(μs)
isFluidCompressible = true;

# squirmer
radius = 4;
slipSpeed = 1e-3;
beta = -5;
coupleTorques = false;
coupleForces = false;

# simulation
simulationTime = 20e3; # μs
ticksSaved = 100; # (about) 100 snapshots are saved
