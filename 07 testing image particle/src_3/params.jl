#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# # space
# #= x = range(-2, stop = 2, step = 0.05) =#
# x = range(0, stop = 12, step = 0.008)
# walledDimensions = [1,2];
#
# # fluid
# relaxationTimeRatio = 1.1;
# isFluidCompressible = false;
#
# # particle
# massDensity = 1.;
# radius = 0.4;
# position = [6, 0.6];
# #= position = [0, 0.]; =#
# coupleTorques = false;
# coupleForces = true;
# angularVelocity = 0.01;
#
# # simulation
# simulationTime = 1;
# ticksBetweenSaves = 150;

#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 6
x = range(-xmax, stop = xmax, step = 0.01);
walledDimensions = [1,2];

# fluid
relaxationTimeRatio = 1.1;
isFluidCompressible = false;

# particle
massDensity = 1.;
radius = 0.4;
position = [0, 0.6-xmax];
coupleTorques = false;
coupleForces = true;
angularVelocity = 0.01;

# simulation
simulationTime = 60;
ticksBetweenSaves = 100;
