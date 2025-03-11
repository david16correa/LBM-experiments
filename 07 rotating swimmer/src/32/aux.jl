import LBMengine.addBead!, LBMengine.moveParticles!, LBMengine.bulkVelocity, LBMengine.cross, LBMengine.writeParticleTrajectory
import LinearAlgebra.norm

function bulkVelocity(model::LBMmodel, particle::LBMparticle, X::Vector)
    xMinusR = X - particle.position
    xMinusR[3] = 0;
    xMinusR_norm = xMinusR |> norm

    :ladd in model.schemes && (abs(xMinusR_norm - particle.particleParams.radius) > model.spaceTime.latticeParameter) && return zero(particle.position)

    bulkV = particle.velocity + cross(particle.angularVelocity, xMinusR)

    (:bead in particle.particleParams.properties || xMinusR_norm == 0) && (return bulkV)

    @assert :squirmer in particle.particleParams.properties "As of right now, only beads and squirmers are supported."

    # fancyR := (x - R)/|x - R|, following Griffiths electrodynamics. This helps me read.
    fancyR = xMinusR/xMinusR_norm

    e_dot_fancyR = dot(particle.particleParams.swimmingDirection, fancyR);

    firstTerm = particle.particleParams.B1 + particle.particleParams.B2 * e_dot_fancyR
    secondTerm = e_dot_fancyR * fancyR - particle.particleParams.swimmingDirection

    #= return (firstTerm * secondTerm) * xMinusR_norm / particle.particleParams.radius + bulkV =#
    return firstTerm * secondTerm + bulkV
end

function addBead!(model::LBMmodel;
    massDensity = 1.0,
    radius = 0.1,
    position = :default, # default: origin (actual value is dimensionality dependent)
    velocity = :default, # default: static (actual value is dimensionality dependent)
    angularVelocity = :default, # default: static, (actual value is dimensionality dependent)
    coupleTorques = false,
    coupleForces = false,
    scheme = :default # default: ladd
)
    # a local function for the general geometry of a centered bead (sphere) is defined
    beadGeometry(x::Vector; radius2 = 0.0625) = sum(x[1:2].^2) < radius2

    # the mass is found using the mass density
    mass = massDensity * sum(beadGeometry.(model.spaceTime.X; radius2 = radius^2)) * model.spaceTime.latticeParameter^model.spaceTime.dims

    # position and velocity are defined if necessary
    position == :default && (position = fill(0., model.spaceTime.dims))
    velocity == :default && (velocity = fill(0., model.spaceTime.dims))
    # the dimensions are checked
    ((length(position) != length(velocity)) || (length(position) != model.spaceTime.dims)) && error("The position and velocity dimensions must match the dimensionality of the model! dims = $(model.spaceTime.dims)")

    # the moment of inertia, initial angular velocity, and angular momentum input are all initialized
    if model.spaceTime.dims == 2
        momentOfInertia = 0.5 * mass * radius^2 # moment of inertia for a disk
        angularVelocity == :default && (angularVelocity = 0.)
        angularMomentumInput = 0.
        @assert (angularVelocity isa Number) "In two dimensions, angularVelocity must be a number!"
    elseif model.spaceTime.dims == 3
        momentOfInertia = 0.4 * mass * radius^2 # moment of inertia for a sphere
        angularVelocity == :default && (angularVelocity = [0., 0, 0])
        angularMomentumInput = [0., 0, 0]
        @assert (angularVelocity isa Array) "In three dimensions, angularVelocity must be an array!"
    else
        error("For particle simulation dimensionality must be either 2 or 3! dims = $(model.spaceTime.dims)")
    end

    # the momentum input is defined, and the inputs are turned into vectors to allow for multithreading
    momentumInput = fill(0., model.spaceTime.dims);

    momentumInput = fill(momentumInput, length(model.velocities) + 1)
    angularMomentumInput = fill(angularMomentumInput, length(model.velocities) + 1)

    # a new bead is defined and added to the model
    newBead = LBMparticle(
        length(model.particles) + 1,
        (;radius, inverseMass = 1/mass, inverseMomentOfInertia = 1/momentOfInertia, solidRegionGenerator = x -> beadGeometry(x; radius2 = radius^2), properties = [:spherical, :bead], coupleTorques, coupleForces),
        (; solidRegion = [], streamingInvasionRegions = []),
        position,
        velocity,
        angularVelocity,
        [],
        momentumInput,
        angularMomentumInput,
    )
    append!(model.particles, [newBead]);

    # the schemes of the model are managed
    scheme == :default && (scheme = :ladd)
    @assert (scheme == :psm || scheme == :ladd) "$(scheme) cannot be used as a particle-fluid collision scheme!"

    @assert (newBead.id == 1 || scheme in model.schemes) "$(scheme) cannot be used, as another scheme for particle-fluid collision is being used"

    append!(model.schemes, [scheme])
    model.schemes = model.schemes |> unique
    if !(:bounceBack in model.schemes)
        wallRegion = fill(false, size(model.massDensity))
        (model.spaceTime.dims <= 2) ? (wallRegion = sparse(wallRegion)) : (wallRegion = BitArray(wallRegion))
        streamingInvasionRegions, oppositeVectorId = bounceBackPrep(wallRegion, model.velocities);
        model.boundaryConditionsParams = merge(model.boundaryConditionsParams, (; wallRegion, streamingInvasionRegions, oppositeVectorId));
        scheme == :ladd && (append!(model.schemes, [:bounceBack]))
    end

    moveParticles!(length(model.particles), model; initialSetup = true)

    # saving data
    :saveData in model.schemes && writeParticleTrajectory(model.particles[end], model)

    return nothing
end

