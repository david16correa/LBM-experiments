#= ==========================================================================================
=============================================================================================
params - larger sphere
=============================================================================================
========================================================================================== =#

# space
xmax = 6
x_space = range(-xmax, stop = xmax, step = 0.01);
x = 1:length(x_space)
walledDimensions = [1, 2];

# fluid
relaxationTimeRatio = 1.1;
isFluidCompressible = false;

# particle
massDensity = 1.;
radius = 0.4/step(x_space)*step(x);
position = [xmax, 0.6]/step(x_space)*step(x);
coupleTorques = false;
coupleForces = false;
angularVelocity = 0.01*step(x_space)/step(x);

# simulation
simulationTime = 60 * step(x)/step(x_space);
ticksBetweenSaves = 100;
