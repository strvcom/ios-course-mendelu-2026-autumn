//
//  FloatingNode.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 13.10.2022.
//

import SpriteKit

/// Represents node, which has ilusion of floating (it moves up and down).
final class FloatingNode: SKSpriteNode {
    // MARK: Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        animate()
    }
}

// MARK: Private API
private extension FloatingNode {
    func animate() {
        let startingPointY = position.y

        // Calculation of animation properties based on node size
        // to achieve seemingly "random" animation.
        let smallerSide = size.height < size.width ? size.height : size.width
        // Scale both the travel distance and duration to the node’s size.
        let offset = smallerSide * 0.1
        let duration = smallerSide * 0.02

        run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveTo(
                        y: startingPointY - offset,
                        duration: duration
                    ),
                    SKAction.moveTo(
                        y: startingPointY + offset,
                        duration: duration
                    )
                ])
            )
        )
    }
}
