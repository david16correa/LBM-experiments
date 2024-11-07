#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 50 # mm
x = range(-xmax, stop = xmax, step = 0.1);
walledDimensions = [1,2];

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (mm)²/(s),
# this time I'm using unitary viscosity in the order of water viscosity
viscosity = 1 # (mm)²/(s)
isFluidCompressible = false;

# stokeslet
radius = 0.2; # mm
position = [0., 0];
force = [1e-3, 0.]; # mass density units * mm/s²

# simulation
simulationTime = 500; # s
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
