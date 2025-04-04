#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-30, 30); # μm
dims = 2;

# fluid
viscosity = 1; # (μm)²/(μs)

# particles
radii = [2 2 2]; # μm
positions = [
    [[-20;0]]
    [[-20;-20]]
    [[0;-20]]
]; # μm
# particles - squirmer
swimmingSpeed = 1e-3;
beta = 0;
swimmingDirection = [1,1];

# bonds
hookConstant_linear = 1; # force/length
hookConstant_polar = 1; # force*length/radians

# simulation
simulationTime = 3e4; # μs
ticksSaved = 100;
