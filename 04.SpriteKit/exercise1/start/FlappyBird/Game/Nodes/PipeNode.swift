//
//  PipeNode.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 04.12.2024.
//

import SpriteKit

final class PipeNode: SKNode {
    private let spaceBetweenPipes: CGFloat
    
    let width: CGFloat
    
    init(spaceBetweenPipes: CGFloat) {
        self.spaceBetweenPipes = spaceBetweenPipes
        
        let pipeTexture = SKTexture(imageNamed: Assets.Textures.pipe)
        
        let pipeTextureSize = pipeTexture.size()
        
        self.width = pipeTextureSize.width
        
        super.init()
        
        zPosition = Layer.pipe
        
        createUpPipe(texture: pipeTexture)
        
        createDownPipe(texture: pipeTexture)
        
        createSpaceBetweenPipes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPipe(texture: SKTexture) -> SKSpriteNode {
        let pipe = SKSpriteNode(texture: texture)
        pipe.name = NodeName.pipe
        pipe.physicsBody = SKPhysicsBody(
            texture: texture,
            size: pipe.size
        )
        pipe.physicsBody?.categoryBitMask = Physics.CategoryBitMask.environment
        pipe.physicsBody?.collisionBitMask = Physics.CollisionBitMask.environment
        pipe.physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.environment
        pipe.physicsBody?.isDynamic = false
        return pipe
    }
    
    func createUpPipe(texture: SKTexture) {
        let pipe = createPipe(texture: texture)
        pipe.zRotation = .pi
        pipe.position = CGPoint(
            x: 0,
            y: pipe.size.height * 0.5 + spaceBetweenPipes * 0.5
        )
        addChild(pipe)
    }
    
    func createDownPipe(texture: SKTexture) {
        let pipe = createPipe(texture: texture)
        pipe.position = CGPoint(
            x: 0,
            y: -pipe.size.height * 0.5 - spaceBetweenPipes * 0.5
        )
        addChild(pipe)
    }
    
    func createSpaceBetweenPipes() {
        let spaceNode = SKNode()
        spaceNode.name = NodeName.spaceBetweenPipes
        spaceNode.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: 1,
                height: spaceBetweenPipes
            )
        )
        spaceNode.physicsBody?.categoryBitMask = Physics.CategoryBitMask.spaceBetweenPipes
        spaceNode.physicsBody?.collisionBitMask = 0
        spaceNode.physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.spaceBetweenPipes
        spaceNode.physicsBody?.isDynamic = false
        
        addChild(spaceNode)
    }
    
    func removeSpaceBetweenPipes() {
        guard let spaceNode = children.first(
            where: { $0.name == NodeName.spaceBetweenPipes }
        ) else {
            return
        }
        
        spaceNode.removeFromParent()
    }
}
