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
radii = [2 2 2]; # μm
positions = [
    [[-10;0]]
    [[-10;-10]]
    [[0;-10]]
]; # μm
# particles - squirmer
swimmingSpeed = 1e-3;
beta = 0;
swimmingDirection = [1,1];

# bonds
hookConstant = 1e-1; # either units of force/length (linear bonds) or force*length/radians (polar bonds)

# simulation
simulationTime = 2e4; # μs
ticksSaved = 100;
