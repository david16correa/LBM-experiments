#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 50 # μm
x = range(-xmax, stop = xmax, step = 0.1);

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (mm)²/(s),
viscosity = 0.890 # (μm)²/(μs)
isFluidCompressible = false;
walledDimensions = [1,2];

# particles
radii = [
    2.0, # μm
    2.0, # μm
    2.0, # μm
]
positions = [
    [0, 0.], # μm
    [-10, 0.], # μm
    [10, 0.], # μm
]
amplitudes = [
    0,
    2e-1, # μm
    2e-1, # μm
]
periods = [
    0,
    200, # μs
    200, # μs
]
phases = [
    0,
    0,
    π/2,
]
coupleTorques = false;
coupleForces = false;
scheme = :ladd;

# simulation
simulationTime = 1e3; # μs
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
