#= ==========================================================================================
=============================================================================================
params
=============================================================================================
========================================================================================== =#

# space
xmax = 10 # mm
x = range(-xmax, stop = xmax, step = 0.1);
walledDimensions = [2]; # walls around $y$

# fluid
# water viscosity ≡ μ = 0.890 mPa s, water density ≡ ρ = 1000 kg/m³ → water kinematic shear viscosity ≡ ν ≡ μ/ρ = 0.890 (mm)²/(s),
viscosity = 0.890 # (mm)²/(s)
kineticParameter = 3/16; # in principle, the best for poiseuille; Krüger p.429
isFluidCompressible = false;

# wall
h = 5;
solidNodes = [j > h || j < -h for i in x, j in x];

# pressure gradient
forceDensity = [1e-2, 0.0] # water density units * mm/s²

# simulation
simulationTime = 100; # s
ticksBetweenSaves = 100 |> snapshots -> simulationTime / step(x) / snapshots |> round |> Int64; # (about) 100 snapshots are saved
