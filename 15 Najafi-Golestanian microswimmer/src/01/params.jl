#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 20 # mm
x = range(-xmax, stop = xmax, step = 0.1);

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (mm)²/(s),
viscosity = 0.890 # (mm)²/(s)
isFluidCompressible = false;

# particles
radii = [
    1.0, # mm
    1.0, # mm
    0.5, # mm
]
positions = [
    [0, 0.], # mm
    [-5, 0.], # mm
    [3, 0.], # mm
]
coupleTorques = false;
coupleForces = false;
scheme = :ladd;

# oscillating particles
amplitudes = [
    0,
    2e-1, # mm
    1e-1, # mm
]
periods = [
    0,
    100, # s
    150, # s
]

# simulation
simulationTime = 1e3; # s
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
