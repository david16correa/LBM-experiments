#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
x = range(-2, stop = 2, length = 500);
walledDimensions = [1,2];

# fluid
relaxationTimeRatio = 1.1;
isFluidCompressible = false;

# wall
solidNodes = [j < -0.6 for i in x, j in x];

# particle
massDensity = 1.;
radius = 0.4;
position = [0., 0];
coupleTorques = false;
coupleForces = true;
angularVelocity = 0.01;

# simulation
simulationTime = 60;