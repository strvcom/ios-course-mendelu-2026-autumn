//
//  HurtBox.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 02.10.2022.
//

import SpriteKit

/// Hurtbox show an area, which can hit a hitbox, hence cause damage. To see hutbox during development,
/// set  `Environment` `showHitboxesAndHurtBoxes` value to `true`.
final class HurtBox: SKSpriteNode {
    convenience init(
        size: CGSize,
        position: CGPoint = .zero
    ) {
        self.init(
            texture: nil,
            color: Environment.showHitboxesAndHurtBoxes
                ? .red
                : .clear,
            size: size
        )

        self.position = position
        self.zPosition = Layer.Relative.same
    }
}
