#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 6
x = range(-xmax, stop = xmax, step = 0.01);
walledDimensions = [1,2];

# fluid
relaxationTimeRatio = 3.1;
isFluidCompressible = false;

# particle
massDensity = 1.;
radius = 0.4;
position = [0, 0.6-xmax];
coupleTorques = false;
coupleForces = true;
angularVelocity = 0.01;

# simulation
simulationTime = 60;
ticksBetweenSaves = 100;
