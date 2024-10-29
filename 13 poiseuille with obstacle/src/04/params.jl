#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 30 #
x = range(-xmax, stop = xmax, step = 0.1);

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (mm)²/(s),
viscosity = 0.890e-2 # (mm)²/(s)
massDensity = 1e2
isFluidCompressible = false;

# wall
h = 10;
solidNodes = [j > h || j < -h for i in x, j in x];

# pressure gradient
forceDensity = [1e-4, 0.0] # water density units * mm/s²

# particle
radius = 1.0;
position = [-5, 0.];
coupleTorques = false;
coupleForces = false;
scheme = :ladd;

# simulation
simulationTime = 100; # s
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
