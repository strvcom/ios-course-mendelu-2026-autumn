//
//  Camera.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 26.09.2022.
//

import SpriteKit

/// Camera represents `camera` object in `LevelScene`. It's centered on `Player` and contains the entire game UI.
final class Camera: SKCameraNode {
    // MARK: Properties
    private var constrainedCameraSize = CGSize.zero
    private var constrainedMapSize = CGSize.zero

    private var safeArea: UIEdgeInsets {
        scene?.view?.safeAreaInsets ?? .zero
    }

    private var sceneSize: CGSize {
        scene?.size ?? .zero
    }

    var cameraSize: CGSize {
        CGSize(
            width: sceneSize.width * xScale,
            height: sceneSize.height * yScale
        )
    }

    var bottomLeftCorner: CGPoint {
        CGPoint(
            x: -(sceneSize.width / 2) + safeArea.left,
            y: -(sceneSize.height / 2) + safeArea.bottom
        )
    }

    var bottomRightCorner: CGPoint {
        CGPoint(
            x: (sceneSize.width / 2) - safeArea.right,
            y: -(sceneSize.height / 2) + safeArea.bottom
        )
    }
}

// MARK: GameObject
extension Camera: SceneObject {
    func setup(scene: LevelScene) {
        zPosition = Layer.Relative.same
        scene.camera = self
        scene.addChild(self)

        // We can change camera size only with xScale and yScale,
        // we cannot provide concrete CGSize.
        xScale = 0.7
        yScale = 0.7
        updateConstraints(scene: scene)
    }

    func update(_ currentTime: TimeInterval) {
        guard let scene = levelScene else {
            return
        }
        let mapSize = scene.level.ground.mapSize
        if cameraSize != constrainedCameraSize
            || mapSize != constrainedMapSize {
            updateConstraints(scene: scene)
        }
    }

    private func updateConstraints(scene: LevelScene) {
        let visibleSize = cameraSize
        let mapSize = scene.level.ground.mapSize
        constrainedCameraSize = visibleSize
        constrainedMapSize = mapSize

        // Follow the player first, then keep the viewport inside the map.
        // If the viewport is larger than the map, center it on that axis.
        let minX = min(
            visibleSize.width / 2,
            mapSize.width / 2
        )
        let maxX = max(
            mapSize.width - visibleSize.width / 2,
            mapSize.width / 2
        )
        let minY = min(
            visibleSize.height / 2,
            mapSize.height / 2
        )
        let maxY = max(
            mapSize.height - visibleSize.height / 2,
            mapSize.height / 2
        )
        let follow = SKConstraint.distance(
            SKRange(constantValue: 0),
            to: scene.player
        )
        let bounds = SKConstraint.positionX(
            SKRange(
                lowerLimit: minX,
                upperLimit: maxX
            ),
            y: SKRange(
                lowerLimit: minY,
                upperLimit: maxY
            )
        )
        bounds.referenceNode = scene
        constraints = [follow, bounds]
    }
}
