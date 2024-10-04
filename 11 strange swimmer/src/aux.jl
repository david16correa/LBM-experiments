#= ==========================================================================================
=============================================================================================
moedifying methods to create this particular swimmer
=============================================================================================
========================================================================================== =#

import LBMengine.moveParticles!, LBMengine.cross, LBMengine.eulerStep!
using SparseArrays

function moveParticles!(id::Int64, model::LBMmodel; initialSetup = false)
    # the particle is named locally for readibility
    particle = model.particles[id]
    # these are used to avoid unnecessary analyses (these analyses, however, are necessary during initial setup)
    particleMoved = initialSetup
    nodeVelocityMustBeFound = initialSetup

    # the velocity and angular velocity are updated, and the particle is moved (this is not necessary in the initial setup)
    if !initialSetup
        particle.velocity += particle.particleParams.inverseMass * particle.momentumInput
        particle.angularVelocity += particle.particleParams.inverseMomentOfInertia * particle.angularMomentumInput
        # the particle will be moved only if the velocity is nonzero! (there are no methods for rotating particles)
        (particle.velocity |> v -> v != zero(v)) && (eulerStep!(id, model); particleMoved = true)
        # the node velocity needs to be found if a) the angular velocity changed, or b) the particle moved
        ((particle.angularMomentumInput |> v -> v != zero(v)) || particleMoved) && (nodeVelocityMustBeFound = true)
    end

    # the inputs are reset
    particle.momentumInput = particle.momentumInput |> zero
    particle.angularMomentumInput = particle.angularMomentumInput |> zero

    # the projection of the particle onto the lattice is found, along with its boundary nodes (streaming invasion regions)
    if particleMoved
        # the particle discretisation on the lattice is updated
        solidRegion = [particle.particleParams.solidRegionGenerator(x - particle.position) for x in model.spaceTime.X]
        #= solidRegion != particle.boundaryConditionsParams.solidRegion && println("ups") =#
        model.spaceTime.dims < 3 && (solidRegion = sparse(solidRegion))

        particle.boundaryConditionsParams = (; solidRegion);

        if :ladd in model.schemes
            # the new streaming invasion regions are found
            streamingInvasionRegions = bounceBackPrep(solidRegion, model.velocities; returnStreamingInvasionRegions = true)
            interiorStreamingInvasionRegions = bounceBackPrep(solidRegion .|> b -> !b, model.velocities; returnStreamingInvasionRegions = true)
            for id in eachindex(model.boundaryConditionsParams.oppositeVectorId)
                streamingInvasionRegions[id] = streamingInvasionRegions[id] .|| interiorStreamingInvasionRegions[id]
            end
            # everything is stored in the original particle
            particle.boundaryConditionsParams = merge(particle.boundaryConditionsParams, (; streamingInvasionRegions));
        end

    end

    # the solid velocity (momentum density / mass density) is found
    if nodeVelocityMustBeFound
        particle.nodeVelocity = [[0. for _ in 1:model.spaceTime.dims] for _ in particle.boundaryConditionsParams.solidRegion]
        particle.nodeVelocity[particle.boundaryConditionsParams.solidRegion] = [
            (model.spaceTime.X[id] - particle.position |> v -> particle.velocity + (cross(sign(v[2]) * particle.angularVelocity, v)))
        for id in findall(particle.boundaryConditionsParams.solidRegion)]
    end
end

