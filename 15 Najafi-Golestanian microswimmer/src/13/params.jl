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
    1.0, # μm
    1.0, # μm
]
positions = [
    [0, 0.], # μm
    [-6, 0.], # μm
]
amplitudes = [
    0, # μm
    1e-1, # μm
]
periods = [
    Inf,
    200, # μs
]
phases = [
    0, # rad
    0, # rad
]
coupleTorques = false;
coupleForces = false;
scheme = :ladd;

# simulation
simulationTime = 1e3; # μs
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
