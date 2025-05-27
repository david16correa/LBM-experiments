#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-60, 60); # μm
dims = 2;

# fluid
viscosity = 1; # (μm)²/(μs)
isFluidCompressible = true;

# squirmer
radius = 4; # μm
swimmingSpeed = 1e-3; # rad/μs
beta = 0;
coupleTorques = true;
coupleForces = false;

# positions of squirmers
aux = range(xlims[1]+1.5radius, stop = xlims[2]-1.5radius, step = 3radius)
positions = [[x, y] for x in aux, y in aux]

# simulation
simulationTime = 10e3; # μs
ticksSaved = 100;
