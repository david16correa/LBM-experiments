#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
x = range(-1, stop = 1, length = 101);
walledDimensions = [];

# fluid
relaxationTimeRatio = 1.1;
isFluidCompressible = false;

# wall
speed = 0.01
h = 1 - 0.1
solidNodes = [-h > j || j > h for i in x, j in x];
solidNodeVelocity = [j > h ? [speed, 0] : j < -h ? [-speed, 0] : [0., 0] for i in x, j in x];

# particle
massDensity = 1.5;
radius = 0.2;
position = [0., 0];
coupleTorques = true;
coupleForces = false;
angularVelocity = 0.0;

# simulation
simulationTime = 60;
