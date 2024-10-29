#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 20 #
x = range(-xmax, stop = xmax, step = 0.1);

# fluid
viscosity = 4/3*1e-1; # 0.133 L^2/T
isFluidCompressible = true;
collisionModel = :trt;

# wall
h = 10;
solidNodes = [j > h || j < -h for i in x, j in x];

# pressure gradient
forceDensity = [1e-2, 0.0]

# particle
radius = 1.0;
position = [-5, 0.];
coupleTorques = false;
coupleForces = false;
scheme = :ladd;

# simulation
simulationTime = 100;
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
