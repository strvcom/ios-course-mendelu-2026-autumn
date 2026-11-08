//
//  AnimatedObject.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 01.10.2022.
//

import SpriteKit

/// Used in all objects, which use `SKTextureAtlas`.
///
/// When working with this object, first, define all animations in `animations` dictionary,
/// then call `playAnimation` with particular key. If key is not in dictionary, nothing happens.
protocol AnimatedObject {
    var animations: [String: SKAction] { get }

    /// Plays animation under given `key` from `animations` dictionary. It's safe to call
    /// this function multiple times in a row with same key.
    func playAnimation(key: String)
}

// MARK: AnimatedObject + SKNode
extension AnimatedObject where Self: SKNode {
    func playAnimation(key: String) {
        guard
            // We check if we are not going to play the same animation again.
            action(forKey: key) == nil,
            let action = animations[key]
        else {
            return
        }

        // We remove only actions for animations, since other actions can be
        // run on `AnimationObject` as well.
        for animation in animations.keys {
            removeAction(forKey: animation)
        }

        run(
            action,
            withKey: key
        )
    }
}
