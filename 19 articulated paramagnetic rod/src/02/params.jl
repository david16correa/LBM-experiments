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
nBeads = 5; # must be odd; otherwise the rod won't have a clear fulcrum
radius = 2; # μm
# all beads are placed on the x axis, evenly distributed around the origin
xs = range(start=0, step=2.3*radius, length=nBeads/2|>ceil|>Integer) |> collect |> v -> cat(v, -v[2:end]; dims = 1) |> unique |> sort # μm; 
coupleForces = true;
coupleTorques = true;

# linear bonds
bondPairs = [(id, id+1) for id in 1:nBeads-1]
stiffness = 1 # mN/m

# polar bonds
bondTriplets = [(1,2,3), (3,4,5)]
equilibriumAngle = pi # rad

# magnetic dipoles
magneticField = [0, 5] # mT

# simulation
simulationTime = 20e3; # μs
ticksSaved = 100;
