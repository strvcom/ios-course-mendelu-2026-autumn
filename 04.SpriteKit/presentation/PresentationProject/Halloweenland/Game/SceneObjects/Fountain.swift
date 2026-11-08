//
//  Fountain.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 04.10.2022.
//

import SpriteKit

/// Represnets bloody fountain object.
final class Fountain: SKSpriteNode {
    // MARK: Properties
    private let fountainFlowFrames = SKTextureAtlas(named: Assets.Atlas.fountainFlowing).textures

    private(set) var animations = [String : SKAction]()
}

// MARK: SceneObject
extension Fountain: SceneObject {
    func setup(scene: LevelScene) {
        setupAction()

        setupFountain()
    }

    func update(_ currentTime: TimeInterval) {
        playAnimation(key: Constants.Animations.fountainFlowing.rawValue)
    }
}

// MARK: AnimatedObject
extension Fountain: AnimatedObject {}

// MARK: Private API
private extension Fountain {
    func setupFountain() {
        zPosition = Layer.scenery
    }

    func setupAction() {
        animations[Constants.Animations.fountainFlowing.rawValue] = SKAction.repeatForever(
            SKAction.animate(
                with: fountainFlowFrames,
                timePerFrame: 0.12,
                resize: false,
                restore: true
            )
        )
    }
}

private enum Constants {
    enum Animations: String {
        case fountainFlowing
    }
}
