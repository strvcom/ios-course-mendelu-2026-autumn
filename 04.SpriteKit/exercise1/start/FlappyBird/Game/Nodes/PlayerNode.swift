//
//  BirdNode.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 28.11.2023.
//

import SpriteKit

final class PlayerNode: SKSpriteNode {
    init() {
        let textureAtlas = SKTextureAtlas(named: Assets.Textures.bird)
        
        let textures = textureAtlas
            .textureNames
            .sorted()
            .map { textureAtlas.textureNamed($0) }
        
        super.init(
            texture: textures.first,
            color: .clear,
            size: textures.first?.size() ?? .zero
        )
        
        zPosition = Layer.player
        name = NodeName.player
        
        physicsBody = SKPhysicsBody(
            texture: texture ?? SKTexture(),
            size: texture?.size() ?? .zero
        )
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.player
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.player
        physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.player
        
        run(
            SKAction.repeatForever(
                SKAction.animate(
                    with: textures,
                    timePerFrame: 0.3,
                    resize: false,
                    restore: true
                )
            )
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flapWings() {
        physicsBody?.applyImpulse(
            CGVector(
                dx: 0,
                dy: size.height * 0.7
            )
        )
    }
    
    func updateRotation() {
        guard let velocity = physicsBody?.velocity.dy else {
            return
        }
        
        zRotation = velocity * 0.001
    }
}
