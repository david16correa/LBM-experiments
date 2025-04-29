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
nBeads = 7;
radius = 3; # μm
separation = 2.3*radius
coupleForces = true;
coupleTorques = true;

# linear bonds
bondPairs = [(id, id+1) for id in 1:nBeads-1]

# polar bonds
bondTriplets = [
    (1,2,3)
    (3,4,5)
    (5,6,7)
]

# moving arms
period = 1000
function equilibriumAngle(t; period = period, amplitude = pi/4, phase = 0) # μs; μs, rad
    t =(t+phase*period)%period |> abs;
    if t < 0.25*period
        return pi + amplitude
    elseif t < 0.5*period
        return pi + amplitude * (1 - 2 * (t - 0.25*period)/(0.5*period - 0.25*period))
    elseif t < 0.75*period
        return pi - amplitude
    else
        return pi + amplitude * (-1 + 2 * (t - 0.75*period)/(period - 0.75*period))
    end
end
hingeTriplets = [(2,3,4), (4,5,6)]
equilibriumAngles = [
    t -> equilibriumAngle(t; phase=0.125)
    t -> equilibriumAngle(t; phase=0.875)
]
# initial positions
xs = [
    2*separation*cos(equilibriumAngles[1](0)) - separation
    1*separation*cos(equilibriumAngles[1](0)) - separation
    - separation
    0
    separation
    2*separation
    3*separation
]
ys = [
    -2*separation*sin(equilibriumAngles[1](0))
    -1*separation*sin(equilibriumAngles[1](0))
    0
    0
    0
    0
    1
]

# simulation
simulationTime = 40e3; # μs
ticksSaved = 100;

simulationTime = 50; # μs
ticksSaved = 2;
