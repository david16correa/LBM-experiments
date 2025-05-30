#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-20, 20); # μm
latticeParameter = 0.1; # μm

# fluid
relaxationTimeRatio = 1.1;
isFluidCompressible = false;

# squirmer
radius = 4;
position = [-1., 0];
slipSpeed = 1e-3;
beta = -5;
coupleTorques = false;
coupleForces = true;
scheme = :psm;

# simulation
simulationTime = 10e3; # μs
ticksBetweenSaves = 10 |> snapshots -> simulationTime / latticeParameter / snapshots |> round |> Int64; # (about) 10 snapshots are saved
