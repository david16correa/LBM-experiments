#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-100,100); # μm
dims = 2;

# fluid
viscosity = 1; # (μm)²/(μs)

# beads
radius = 3; # μm
separation = 2.3*radius # μm
coupleForces = true;
coupleTorques = false;

# moving arms
bondPairs = [(1,2), (2,3)]

period, amplitude = 1e1, 1e-1 # μs, μm
equilibriumDisplacements = [
    t -> separation + amplitude * sin(2*pi/period * t - pi/2) # μm
    t -> separation + amplitude * sin(2*pi/period * t) # μm
]
# initial positions
xs = [equilibriumDisplacements[1](0); 0; -equilibriumDisplacements[2](0)] # μm
ys = [0 0 0] # μm

# simulation
simulationTime = 20e3; # μs
ticksSaved = 100;
