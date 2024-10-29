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
viscosity = 0.0089; # (cm)²/(s)
isFluidCompressible = false;

# driving block
forceDensity = [(abs(i) > 27.5) && (abs(j) < 3) ? [1e-3, 0] : [0., 0] for i in x, j in x]

# particle
radius = 2.0;
position = [-20, 0.];
coupleTorques = false;
coupleForces = false;
scheme = :ladd;

# simulation
simulationTime = 500; # s
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved