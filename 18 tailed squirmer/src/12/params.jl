#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-100,100); # μm
ylims = (-50,50); # μm
dims = 2;

# fluid
viscosity = 1; # (μm)²/(μs)

# beads
radius = 3; # μm
nBeads = 6
xs = range(stop=0, step=radius*2.3, length=nBeads) |> collect # μm
coupleForces = true;
coupleTorques = true;

# squirmer
swimmingSpeed = 1e-3;
beta = 0;
swimmingDirection = [1,0];

# bonds
bondPairs = [(id, id+1) for id in 1:nBeads-1]
stiffness = 1 # mN/m

# simulation
simulationTime = 1e3; # μs
ticksSaved = 10;
