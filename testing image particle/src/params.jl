#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
x = range(-2, stop = 2, length = 201);
walledDimensions = [2];

# fluid
relaxationTimeRatio = 1.1;
isFluidCompressible = true;

# wall
solidNodes = [j < -0.5 for i in x, j in x];

# particle
massDensity = 1.5e-0;
radius = 0.2;
position = [0., 0];
coupleTorques = false;
coupleForces = false;
angularVelocity = 0.05;

# simulation
simulationTime = 60;
