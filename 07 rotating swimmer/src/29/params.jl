#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-10, 10);
dims = 3;
walledDimensions = [1,2,3];

# fluid
viscosity = 1; # (μm)²/(μs)
isFluidCompressible = true;

# particle
radius = 1; # μm
position = [0, 0, -8.5]; # μm
angularVelocity = [-1e-6, 0, 0]; # rad/μm must swim towards +y
coupleForces = true;
coupleTorques = false;

# simulation
simulationTime = 1e3; # μs
ticksSaved = 10;
