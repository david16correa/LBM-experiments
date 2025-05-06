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
nLinks = 2;
nBeads = 2*nLinks+1;
radius = 2; # μm
equilibriumDisplacement = 2.3*radius
# all beads are placed on the x axis, evenly distributed around the origin
xs = range(start=0, step=equilibriumDisplacement, length=nBeads/2|>ceil|>Integer) |> collect |> v -> cat(v, -v[2:end]; dims = 1) |> unique |> sort # μm;
coupleForces = true;
coupleTorques = true;

# linear bonds
bondPairs = [(id, id+1) for id in 1:nBeads-1] # (1,2), (2,3), ..., (nBeads - 1, nBeads)
stiffness = 1 # mN/m

# polar bonds
bondTriplets = [(Id, Id+1, Id+2) for Id in 1:nBeads if Id%2==1][1:end-1] # (1,2,3), (3,4,5), ..., (nBeads - 2, nBeads - 1, nBeads)
equilibriumAngle = pi # rad

# magnetic dipoles
magneticField = [0, 5] # mT

# simulation
simulationTime = 40e3; # μs
ticksSaved = 100;
