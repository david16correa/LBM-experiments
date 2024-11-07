#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 50 # mm
x = range(-xmax, stop = xmax, step = 0.1);
walledDimensions = [1,2];

# fluid
viscosity = 100 # (mm)²/(s)
isFluidCompressible = false;

# stokeslet
position = [0., 0];
force = [1e-3, 0.]; # mass density units * mm/s²

# simulation
simulationTime = 100; # s
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
