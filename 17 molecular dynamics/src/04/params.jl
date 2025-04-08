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
radii = [1 1]; # μm
positions = [
    [[-5,0]]
    [[5,0]]
]; # μm
coupleForces = true;
coupleTorques = false;

# magnetic field
period = 10 # μs
magneticField(t) = 10*[sin(t * 2pi / period); cos(t * 2pi / period)] # mT

# linear bond
hookConstant = 1e-1; # force/length

# simulation
simulationTime = 50e3; # μs
ticksSaved = 100;
