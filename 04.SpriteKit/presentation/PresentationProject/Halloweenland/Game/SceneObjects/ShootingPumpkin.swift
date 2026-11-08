//
//  ShootingPumpkin.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 02.10.2022.
//

import SpriteKit

final class ShootingPumpkin: SKSpriteNode {
    // MARK: Properties
    private let eatingFrames = SKTextureAtlas(named: Assets.Atlas.pumpkinEating).textures

    private(set) var animations = [String : SKAction]()
}

// MARK: SceneObject
extension ShootingPumpkin: SceneObject {
    func setup(scene: LevelScene) {
        setupActions()

        setupPumpkin()
    }

    func update(_ currentTime: TimeInterval) {
        playAnimation(key: Constants.Animations.eating.rawValue)
    }

    func handleContactStart(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == ObjectNames.projectile {
            handleProjectileHit(
                with: contact.bodyB,
                projectile: contact.bodyA
            )
        } else if contact.bodyB.node?.name == ObjectNames.projectile {
            handleProjectileHit(
                with: contact.bodyA,
                projectile: contact.bodyB
            )
        }
    }
}

// MARK: AnimatedObject
extension ShootingPumpkin: AnimatedObject {}

// MARK: Private API
private extension ShootingPumpkin {
    func setupPumpkin() {
        zPosition = Layer.world
    }

    func setupActions() {
        let eatingTimePerFrame: TimeInterval = 0.25

        // Wait duration is duration between frames when pumpkin has its
        // mouth opened. When the pumpkin has fully opened mouth, we will
        // shoot pumpkin out of them.
        // Fire halfway through the eating animation.
        let waitDuration = (Double(eatingFrames.count) / 2) * eatingTimePerFrame

        animations[Constants.Animations.eating.rawValue] = SKAction.repeatForever(
            SKAction.group([
                SKAction.sequence([
                    SKAction.wait(forDuration: waitDuration),
                    SKAction.run { [weak self] in
                        self?.shoot()
                    },
                    SKAction.wait(forDuration: waitDuration)
                ]),
                SKAction.animate(
                    with: eatingFrames,
                    timePerFrame: 0.25,
                    resize: false,
                    restore: true
                )
            ])
        )
    }

    func shoot() {
        // Direction is calculated so that we can rotate pumpkin around y axis
        // without hardcoding anything.
        let pumpkinDirection = Direction(xScale: xScale)

        let projectile = SKSpriteNode(texture: SKTexture(imageNamed: Assets.Image.projectile))
        projectile.name = ObjectNames.projectile
        projectile.zPosition = Layer.characters
        // Node is centered to pumpkin mouth.
        projectile.position = CGPoint(
            x: position.x,
            y: position.y - 20
        )
        // Here, we update projectile node direction according pumpkin direction.
        projectile.updateNodeDirection(direction: pumpkinDirection)
        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        // Gravity is turned of because we don't want projectile to fall on
        // the ground, we want it to travel in straight line.
        projectile.physicsBody?.affectedByGravity = false
        // When fireing a lot of elements in quick succession, we are recommended
        // to enable usesPreciseCollisionDetection, so that all collisions of
        // projectile are going to be properly detected.
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        projectile.physicsBody?.categoryBitMask = Physics.CategoryBitMask.projectile
        projectile.physicsBody?.collisionBitMask = Physics.CollisionBitMask.projectile
        projectile.physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.projectile

        levelScene?.addChild(projectile)

        let dx: Int
        switch pumpkinDirection {
        case .left:
            dx = 2
        case .right:
            dx = -2
        }

        projectile.physicsBody?.applyImpulse(
            CGVector(
                dx: dx,
                dy: 0
            )
        )
    }

    func handleProjectileHit(
        with body: SKPhysicsBody,
        projectile: SKPhysicsBody
    ) {
        projectile.node?.removeFromParent()

        // We only evaluate, if player was hit.
        guard body == levelScene?.player.physicsBody else {
            return
        }

        levelScene?.player.hit()
    }
}

private enum Constants {
    enum Animations: String {
        case eating
    }
}
