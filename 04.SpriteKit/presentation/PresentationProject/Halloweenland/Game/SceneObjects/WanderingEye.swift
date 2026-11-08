//
//  WanderingEye.swift
//  MendeluSpriteKit
//

import SpriteKit

/// An eye that wanders around its starting position and leaves a particle trail while moving.
final class WanderingEye: SKSpriteNode {
    private var home = CGPoint.zero
    private var emitter: SKEmitterNode?

    private func moveAndEmit() {
        let destination = CGPoint(
            x: home.x + CGFloat.random(in: -90...90),
            y: home.y + CGFloat.random(in: -45...45)
        )
        let move = SKAction.move(
            to: destination,
            duration: 1.5
        )
        move.timingMode = .easeInEaseOut
        let start = SKAction.run { [weak self] in
            self?.emitter?.particleBirthRate = 100
        }
        let stop = SKAction.run { [weak self] in
            self?.emitter?.particleBirthRate = 0
        }
        let next = SKAction.run { [weak self] in
            self?.moveAndEmit()
        }
        run(
            .sequence([start, move, stop, .wait(forDuration: 0.4), next]),
            withKey: Constants.wander
        )
    }
}

extension WanderingEye: SceneObject {
    func setup(scene: LevelScene) {
        let eyeTexture = SKTexture(imageNamed: Assets.Image.greenEye)
        texture = eyeTexture
        if size == .zero { size = eyeTexture.size() }
        anchorPoint = CGPoint(
            x: 0.5,
            y: 0.5
        )
        zPosition = Layer.foreground
        home = position

        childNode(withName: ObjectNames.eyeParticles)?.removeFromParent()
        if let particles = SKEmitterNode(fileNamed: Assets.Emitter.eyeParticles) {
            particles.name = ObjectNames.eyeParticles
            particles.particleBirthRate = 0
            let spark = SKTexture(imageNamed: Assets.Image.spark)
            spark.filteringMode = .nearest
            particles.particleTexture = spark
            particles.position = .zero
            particles.particlePosition = .zero
            particles.particlePositionRange = .zero
            // The scene is the target, so place particles in its depth range:
            // above the level, but below the eye in the foreground.
            particles.particleZPosition = Layer.particles
            particles.targetNode = scene
            particles.zPosition = Layer.Relative.same
            addChild(particles)
            emitter = particles
        } else {
            assertionFailure("EyeParticles.sks is missing from the app bundle")
        }
        moveAndEmit()
    }
}

private enum Constants {
    static let wander = "wander"
}
