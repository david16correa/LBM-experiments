#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 50 #
x = range(-xmax, stop = xmax, step = 0.1);
walledDimensions = [1,2];

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (mm)²/(s),
viscosity = 0.890 # (mm)²/(s)
isFluidCompressible = false;

# stokeslet
radius = 1;
position = [0., 0];
force = [1e-3, 0];

# simulation
simulationTime = 100; # s
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
