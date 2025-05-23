#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-20, 20); # μm
dims = 2;

# fluid
viscosity = 1; # (μm)²/(μs)

# particles
radius = 1; # μm
positions = [
    [[-5,0]]
    [[0,0]]
    [[5,0]]
]; # μm
coupleForces = true;
coupleTorques = false;

# magnetic field
period = 100 # μs
magneticField(t) = [sin(t * 2pi / period); cos(t * 2pi / period)] # mT

# linear bond
hookConstant = 1; # force/length

# simulation
simulationTime = 50e3; # μs
ticksSaved = 100;
