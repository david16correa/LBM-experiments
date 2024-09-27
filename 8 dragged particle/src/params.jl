#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
x = range(-1, stop = 1, length = 200);

# fluid
relaxationTimeRatio = 1.1;
isFluidCompressible = true;

# wall
speed = 0.06
solidNodes = [-0.9 > i || i > 0.9 || -0.9 > j || j > 0.9 for i in x, j in x];
solidNodeVelocity = [i > 0.9 ? [0, speed] : i < -0.9 ? [0, -speed] : j > 0.9 ? [-speed, 0] : j < -0.9 ? [speed, 0] : [0., 0] for i in x, j in x];


# particle
massDensity = 1.5;
radius = 0.1;
position = [0, -0.5];
coupleTorques = false;
coupleForces = true;
angularVelocity = 0.0;
scheme = :psm;

# simulation
simulationTime = 60;
