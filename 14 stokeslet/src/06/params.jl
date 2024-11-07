#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 50 # μm
x = range(-xmax, stop = xmax, step = 0.1);
walledDimensions = [];

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (mm)²/(s),
# this time I'm using unitary viscosity in the order of water viscosity
viscosity = 1e3 # (μm)²/(ms)
isFluidCompressible = false;

# stokeslet
position = [0., 0];
force = [1e-3, 0.]; # mass density units * μm/(ms)²

# simulation
simulationTime = 100; # ms
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
