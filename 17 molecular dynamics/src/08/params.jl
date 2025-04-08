#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-20, 20); # μm
walledDimensions = [1,2];
dims = 2;

# fluid
viscosity = 1; # (μm)²/(μs)

# particles
radius = 1; # μm
positions = [
    [[-2,0]]
    [[2,0]]
]; # μm
coupleForces = true;
coupleTorques = false;

# bonds - bistable
height = 0.001 # fJ
lowDisp = 4 # μm

# bonds - spring
hookConstant = 0.05 # force/length
equilibriumDisp = 3.6 # μm

# magnetic field 
normB = 7 # mT
period = 140 # μs
magneticField(t) = normB/2 * (1 - sign(mod(t+period/2,period) - period/2)) # B̂ = ẑ; (0 for half a period, 7 for the half a period)

# simulation
simulationTime = 14e3; # μs
ticksSaved = 100;
