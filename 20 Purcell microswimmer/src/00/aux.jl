import LBMengine.AbstractInteraction, LBMengine.addPolarBond!, LBMengine.applyInteraction!, LBMengine.cross
import LinearAlgebra.norm

struct auxInteraction <: AbstractInteraction
    id1::UInt8
    id2::UInt8
    id3::UInt8
    equilibriumAngle::Function
    stiffness::Float64
end

function addAuxBond!(model::LBMmodel, id1::Int64, id2::Int64, id3::Int64; equilibriumAngle = :default, stiffness = 1)
    particle1 = model.particles[id1]
    particle2 = model.particles[id2]
    particle3 = model.particles[id3]

    vecA = particle1.position - particle2.position
    normA = vecA |> Array |> norm
    vecB = particle3.position - particle2.position
    normB = vecB |> Array |> norm

    cosAlpha = sum(vecA .* vecB) / (normA * normB)

    @assert stiffness isa Number "stiffness must be a number!"

    newInteraction = auxInteraction(
        id1|>UInt8,
        id2|>UInt8,
        id3|>UInt8,
        equilibriumAngle,
        stiffness
    )
    append!(model.particleInteractions, [newInteraction]);

    return nothing
end

function applyInteraction!(model::LBMmodel, interaction::auxInteraction)
    equilibriumAngle = interaction.equilibriumAngle(model.time)
    if equilibriumAngle > pi
        id1 = interaction.id3
        id3 = interaction.id1
        equilibriumAngle = 2pi - equilibriumAngle
    else
        id1 = interaction.id1
        id3 = interaction.id3
    end
    id2 = interaction.id2

    # disp12 := displacement from particle 2 to particle 1
    disp12 = model.particles[id1].position - model.particles[id2].position
    normDisp12 = disp12 |> Array |> norm
    unitDisp12 = disp12/normDisp12
    disp32 = model.particles[id3].position - model.particles[id2].position
    normDisp32 = disp32 |> Array |> norm
    unitDisp32 = disp32/normDisp32

    angle123 = sum(unitDisp12 .* unitDisp32) |> x -> (abs(x)>1 ? sign(x) : x) |> acos
    torqueDirection = cross(unitDisp32, unitDisp12); auxNorm = norm(torqueDirection);
    auxNorm > 0 && (torqueDirection /= auxNorm)
    torque = interaction.stiffness * (angle123 - interaction.equilibriumAngle(model.time)) * torqueDirection
    #= directionCorrection |> println =#
    #= (interaction.id1,interaction.id2,interaction.id3) |> println =#
    #= angle123 |> println =#
    #= equilibriumAngle |> println =#

    # force321 := force acting on particle 1 by virtue of its interaction with particles 2 and 3
    force321 = -cross(torque, unitDisp12) / normDisp12
    model.particles[interaction.id1].forceInput += force321

    force123 = cross(torque, unitDisp32) / normDisp32
    model.particles[interaction.id3].forceInput += force123

    model.particles[interaction.id2].forceInput -= force321 + force123 # conservation of momentum
end
