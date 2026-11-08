//
//  Direction.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 01.10.2022.
//

import SpriteKit

enum Direction {
    case left
    case right

    // MARK: Init
    init(xScale: CGFloat) {
        // You can experiment with xScale in 'sks' file to see, how
        // changing this value transforms sprite.
        self = xScale > 0
            ? .right
            : .left
    }
}

// MARK: SKNode + Direction
extension SKNode {
    func updateNodeDirection(direction: Direction) {
        var multiplierForDirection: CGFloat
        switch direction {
        case .left:
            // When scale is set to -1, sprite will be turn left.
            multiplierForDirection = -1
        case .right:
            // When scale is set to 1, sprite will be turn right.
            multiplierForDirection = 1
        }

        // Any other values than -1 or 1 would deform node, meaning
        // changing its original size.

        // We don't know, if previous value is not negative, therefore
        // we use absolute value.
        xScale = abs(xScale) * multiplierForDirection
    }
}
