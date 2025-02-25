#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-45, 45); # μm
walledDimensions = [1,2]; # walls around y

# fluid
viscosity = 1; # (μm)²/(μs)
isFluidCompressible = true;

# particle
radius = 3; # μm
position = [0, -45+3*1.5]; # μm
coupleTorques = false;
coupleForces = true;
angularVelocity = 1/3*1e-3; # rad/μs

# simulation
simulationTime = 20e3; # μs
ticksSaved = 100;
