#= ==========================================================================================
=============================================================================================
modifying methods to create this particular swimmer
=============================================================================================
========================================================================================== =#

import LBMengine.moveParticles!, LBMengine.bounceBackPrep
using SparseArrays

function moveParticles!(id::Int64, model::LBMmodel; initialSetup = false)
    # the first particle will never move
    id == 1 && !initialSetup && return

    # the particle is named locally for readibility
    particle = model.particles[id]

    # these lines will only happen if id == 2 || id == 3, or during the initial setup
    particle.position[1] = amplitudes[id] * cos(2π/periods[id] * model.time + phases[id]) + positions[id][1]
    particle.velocity[1] = -amplitudes[id] * 2π/periods[id] * sin(2π/periods[id] * model.time + phases[id])

    # the second and third particles must always move, and the following lines need to be calculated for first particle during the initial setup

    #= if particleMoved =#
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

    #= end =#

    # the solid velocity (momentum density / mass density) is found
    #= if nodeVelocityMustBeFound =#
        particle.nodeVelocity = [[0. for _ in 1:model.spaceTime.dims] for _ in particle.boundaryConditionsParams.solidRegion]
        particle.nodeVelocity[particle.boundaryConditionsParams.solidRegion] = [
            particle.velocity
        for id in findall(particle.boundaryConditionsParams.solidRegion)]
    #= end =#
end
