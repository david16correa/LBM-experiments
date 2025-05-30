#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-15, 15); # μm
walledDimensions = [1,2];

# fluid
viscosity = 1; # (μm)²/(μs)
isFluidCompressible = true;

# particle
radius = 1.0; # μm
position = [0, 1.5-xlims[2]]; # μm
coupleTorques = false;
coupleForces = true;
angularVelocity = 1e-6; # rad/μs

# simulation
simulationTime = 5e3; # μs
ticksSaved = 500;
