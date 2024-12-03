#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xlims = (-125, 125); # μm
ylims = (-20, 20); # μm
latticeParameter = 0.1; # μm
walledDimensions = [1,2];
dampenEcho = true;

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (mm)²/(s),
viscosity = 0.890 # (μm)²/(μs)
isFluidCompressible = false;
walledDimensions = [1,2];

# particles
radii = [
    1.0, # μm
    1.0, # μm
    1.0, # μm
]
positions = [
    [0, 0.], # μm
    [-6, 0.], # μm
    [6, 0.], # μm
]
amplitudes = [
    0,
    1e-1, # μm
    1e-1, # μm
]
periods = [
    Inf,
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
simulationTime = 3e3; # μs
ticksBetweenSaves = 20/latticeParameter |> round |> Int64; # 20 μs between snapshots
#= ticksBetweenSaves = 100 |> snapshots -> simulationTime / latticeParameter / snapshots |> round |> Int64; # (about) 100 snapshots are saved =#
