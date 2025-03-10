#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-15, 15); # μm
dims = 3;
walledDimensions = [1,2,3];

# fluid
viscosity = 1; # (μm)²/(μs)
isFluidCompressible = true;

# particle
radius = 1; # μm
position = [0, 1.5-xlims[2], 0]; # μm
coupleForces = true;
coupleTorques = false;
angularVelocity = [0,0,1e-6]; # rad/μm must swim towards -x

# simulation
simulationTime = 1e3; # μs
ticksSaved = 10;
