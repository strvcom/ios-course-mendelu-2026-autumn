//
//  BackgroundNode.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 28.11.2023.
//

import SpriteKit

final class BackgroundNode: SKSpriteNode {
    static let size = SKTexture(imageNamed: Assets.Textures.background).size()
    
    init() {
        let texture = SKTexture(imageNamed: Assets.Textures.background)
        
        super.init(
            texture: texture,
            color: .clear,
            size: texture.size()
        )
        
        zPosition = Layer.background
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
