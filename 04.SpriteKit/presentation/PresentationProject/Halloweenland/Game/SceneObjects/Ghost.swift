//
//  Ghost.swift
//  MendeluSpriteKit
//

import SpriteKit
import UIKit

/// A floating ghost that lights the nearby ground.
final class Ghost: SKSpriteNode {
}

// MARK: SceneObject
extension Ghost: SceneObject {
    func setup(scene: LevelScene) {
        let ghostTexture = SKTexture(imageNamed: Assets.Image.ghost)

        texture = ghostTexture

        if size == .zero {
            size = ghostTexture.size()
        }

        alpha = 0.8
        zPosition = Layer.scenery

        anchorPoint = CGPoint(
            x: 0.5,
            y: 0.5
        )

        // Tile maps need a matching mask to receive light. The ambient color
        // below keeps the rest of the ground visible outside the light.
        scene.level.ground.lightingBitMask |= Lighting.ghost

        childNode(withName: ObjectNames.ghostLight)?.removeFromParent()
        let light = SKLightNode()
        light.name = ObjectNames.ghostLight
        light.categoryBitMask = Lighting.ghost
        light.lightColor = UIColor(
            red: 0.65,
            green: 0.9,
            blue: 1,
            alpha: 1
        )
        light.ambientColor = UIColor(
            white: 0.45,
            alpha: 1
        )
        light.falloff = 0.7
        // Aim the light toward the ground beneath the ghost.
        light.position = CGPoint(
            x: 0,
            y: -size.height * 0.5
        )
        light.zPosition = Layer.Relative.furtherAbove
        addChild(light)

        // Scale the floating distance with the sprite and return to its starting point.
        let offset = size.height * 0.3
        let up = SKAction.moveBy(
            x: 0,
            y: offset,
            duration: 1.2
        )
        let down = SKAction.moveBy(
            x: 0,
            y: -offset * 2,
            duration: 2.4
        )
        let back = SKAction.moveBy(
            x: 0,
            y: offset,
            duration: 1.2
        )
        [up, down, back].forEach { $0.timingMode = .easeInEaseOut }
        run(
            .repeatForever(.sequence([up, down, back])),
            withKey: Constants.ghostFloat
        )
    }
}

private enum Constants {
    static let ghostFloat = "ghostFloat"
}
