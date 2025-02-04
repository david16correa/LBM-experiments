#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-50, 50); # μm
latticeParameter = 0.1; # μm

# fluid
relaxationTimeRatio = 1.1;
isFluidCompressible = false;

# squirmer
radius = 4;
slipSpeed = 1e-3;
beta = 5;
coupleTorques = false;
coupleForces = false;
scheme = :ladd;

# simulation
simulationTime = 1e3; # μs
ticksBetweenSaves = 100 |> snapshots -> simulationTime / latticeParameter / snapshots |> round |> Int64; # (about) 100 snapshots are saved
