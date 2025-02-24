#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-40, 40); # μm
ylims = (-10, 10); # μm
walledDimensions = [2]; # walls around y

# fluid
viscosity = 1;
isFluidCompressible = true;

# squirmer
radius = 3; # μm
slipSpeed = 1e-3; # rad/μs
beta = -5;
coupleTorques = false;
coupleForces = true;

# simulation
simulationTime = 50e3; # μs
ticksSaved = 500;
