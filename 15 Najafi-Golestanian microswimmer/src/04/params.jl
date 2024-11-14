#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 50 # mm
x = range(-xmax, stop = xmax, step = 0.1);

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (mm)²/(s),
viscosity = 0.890 # (mm)²/(s)
isFluidCompressible = false;
walledDimensions = [1,2];

# particles
radius = 1.0; # mm
positions = [
    [0, 0.], # mm
    [-5, 0.], # mm
]
coupleTorques = false;
coupleForces = false;
scheme = :ladd;

# oscillating particle
amplitude = 2e-1; # mm
period = 100; # s

# simulation
simulationTime = 1e3; # s
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
