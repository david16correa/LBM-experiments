#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-50, 50); # μm
dims = 2;

# fluid
viscosity = 1; # (μm)²/(μs)

# beads
radius = 1; # μm
xs = range(start=-5.75, step=2.3, length=6); # μm
coupleForces = true;
coupleTorques = true;

# bonds
stiffness = 1 # mN/m
magneticField = [0, 10] # mT

# simulation
simulationTime = 20e3; # μs
ticksSaved = 100;
