#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
x = range(-2, stop = 2, length = 500);
walledDimensions = [];

# fluid
relaxationTimeRatio = 1.1;
isFluidCompressible = false;

# particle
massDensity = 1.;
radius = 0.2;
position = [-1., 0];
coupleTorques = false;
coupleForces = true;
angularVelocity = 0.01;

# simulation
simulationTime = 60;
