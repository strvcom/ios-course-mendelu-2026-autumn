//
//  CGPoint+Extension.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 01.10.2022.
//

import CoreGraphics

extension CGPoint {
    /// Returns distance between 2 points.
    func distance(to point: CGPoint) -> CGFloat {
        // Pythagoras gives the straight-line distance between two points.
        sqrt(pow(
            (point.y - y),
            2
        ) + pow(
            (point.x - x),
            2
        ))
    }

    /// Init with `x` and `y` to same value.
    init(position: CGFloat) {
        self.init(
            x: position,
            y: position
        )
    }
}
