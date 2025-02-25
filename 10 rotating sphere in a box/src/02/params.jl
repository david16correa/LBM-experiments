#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-30, 30); # μm
ylims = (-15, 15); # μm
walledDimensions = [2]; # walls around y

# fluid
viscosity = 1; # (μm)²/(μs)
isFluidCompressible = true;

# particle
radius = 3; # μm
position = [0, 11]; # μm
coupleTorques = false;
coupleForces = true;
angularVelocity = 0.3e-3; # rad/μs

# simulation
simulationTime = 20e3; # μs
ticksSaved = 100;
