//
//  PlayerObservingObject.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 11.10.2022.
//

import SpriteKit

/// Protocol used to prevent copy pasting of code.
protocol PlayerObservingObject: SceneObject, SKNode { }

extension PlayerObservingObject {
    /// Returns current player position, if the position is not available, `.zero` is returned.
    var playerPosition: CGPoint {
        levelScene?.player.position ?? .zero
    }

    var distanceToPlayer: CGFloat {
        playerPosition.distance(to: position)
    }
}
