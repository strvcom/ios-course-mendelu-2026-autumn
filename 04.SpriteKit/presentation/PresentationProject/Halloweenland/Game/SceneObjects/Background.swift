//
//  Background.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import SpriteKit

/// Represents background in `LevelScene`, which consists of 4 layers. It is always going to be scaled
/// on entire ground width.
final class Background {
    // MARK: Properties
    private var backgrounds: [(
        backgroundName: String,
        layer: CGFloat
    )] {
        [
            (
                Assets.Image.background1,
                Layer.background1
            ),
            (
                Assets.Image.background2,
                Layer.background2
            ),
            (
                Assets.Image.background3,
                Layer.background3
            ),
            (
                Assets.Image.background4,
                Layer.background4
            )
        ]
    }
}

// MARK: GameObject
extension Background: SceneObject {
    func setup(scene: LevelScene) {
        let size = calculateNodeSize(scene: scene)

        backgrounds
            .forEach {
                let background = SKSpriteNode(imageNamed: $0.backgroundName)
                background.anchorPoint = .zero
                background.position = .zero
                background.zPosition = $0.layer
                background.size = size

                scene.addChild(background)
            }
    }
}

// MARK: Private API
private extension Background {
    func calculateNodeSize(scene: LevelScene) -> CGSize {
        guard let backgroundImageSize = UIImage(named: backgrounds.first?.backgroundName ?? "")?.size else {
            return .zero
        }

        // Preserve the artwork’s aspect ratio when stretching it across the level.
        let aspectRatio = backgroundImageSize.height / backgroundImageSize.width

        // We don't want to deform the image, so we have to multiply height
        // with image aspect ratio.
        return CGSize(
            width: scene.level.ground.mapSize.width,
            height: scene.level.ground.mapSize.width * aspectRatio
        )
    }
}
