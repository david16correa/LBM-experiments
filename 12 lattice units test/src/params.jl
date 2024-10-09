#= ==========================================================================================
=============================================================================================
params - larger sphere
=============================================================================================
========================================================================================== =#

# space
x_space = range(-2, stop = 2, length = 101);
x = 1.:length(x_space)
walledDimensions = [];

# fluid
relaxationTimeRatio = 1.1;
isFluidCompressible = false;

# wall
solidNodes = [j < -0.6 for i in x_space, j in x_space];

# particle
massDensity = 1.;
radius = 0.4/step(x_space)*step(x);
position = [2, 2]/step(x_space)*step(x);
coupleTorques = false;
coupleForces = false;
angularVelocity = 0.01*step(x_space)/step(x);

# simulation
simulationTime = 30;
