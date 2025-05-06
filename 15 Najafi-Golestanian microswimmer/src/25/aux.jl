import LBMengine.AbstractInteraction, LBMengine.addPolarBond!, LBMengine.applyInteraction!, LBMengine.cross
import LinearAlgebra.norm

struct auxInteraction <: AbstractInteraction
    id1::UInt8
    id2::UInt8
    equilibriumDisplacement::Function
    stiffness::Float64
end

function addAuxBond!(model::LBMmodel, id1::Int64, id2::Int64; equilibriumDisplacement = :default, stiffness = 1)
    particle1 = model.particles[id1]
    particle2 = model.particles[id2]
 
    newInteraction = auxInteraction(
        id1|>UInt8,
        id2|>UInt8,
        equilibriumDisplacement,
        stiffness,
    )
    append!(model.particleInteractions, [newInteraction]);
 
    return nothing
end

function applyInteraction!(model::LBMmodel, interaction::auxInteraction)
    # disp21 := displacement from particle 1 to particle 2
    disp21 = model.particles[interaction.id2].position - model.particles[interaction.id1].position
    disp = disp21 |> Array |> norm # this is actually quicker than disp21 |> norm, which I find annoying
    unitDisp21 = disp21 / disp
 
    # force21 := force acting on particle 1 by virtue of its interaction with particle 2
    force21 = interaction.stiffness * (disp - interaction.equilibriumDisplacement(model.time)) * unitDisp21
 
    model.particles[interaction.id1].forceInput += force21
    model.particles[interaction.id2].forceInput -= force21 # Newton's third law
end
