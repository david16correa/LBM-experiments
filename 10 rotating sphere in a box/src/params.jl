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

# walls of increasing thickness
h1 = 0.1
solidNodes_1 = [-(1 - h1) > i || i > (1 - h1) || -(1 - h1) > j || j > (1 - h1) for i in x, j in x];
h2 = 0.25
solidNodes_2 = [-(1 - h2) > i || i > (1 - h2) || -(1 - h2) > j || j > (1 - h2) for i in x, j in x];
h3 = 0.5
solidNodes_3 = [-(1 - h3) > i || i > (1 - h3) || -(1 - h3) > j || j > (1 - h3) for i in x, j in x];
h4 = 0.75
solidNodes_4 = [-(1 - h4) > i || i > (1 - h4) || -(1 - h4) > j || j > (1 - h4) for i in x, j in x];

# particle
massDensity = 1.5;
radius = 0.2;
position = [0., 0];
coupleTorques = false;
coupleForces = false;
angularVelocity = 0.1;

# simulation
simulationTime = 60;
