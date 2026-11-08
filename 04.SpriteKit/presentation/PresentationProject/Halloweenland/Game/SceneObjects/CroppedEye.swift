import SpriteKit

/// Demonstrates clipping a moving sprite to a circular mask.
final class CroppedEye: SKSpriteNode {}

extension CroppedEye: SceneObject {
    func setup(scene: LevelScene) {
        childNode(withName: ObjectNames.eyeCrop)?.removeFromParent()
        childNode(withName: ObjectNames.cropOutline)?.removeFromParent()

        zPosition = Layer.overlay

        let eye = SKSpriteNode(imageNamed: Assets.Image.greenEye)
        eye.name = ObjectNames.movingEye
        eye.size = CGSize(
            width: 120,
            height: 120
        )
        eye.position = CGPoint(
            x: -90,
            y: 0
        )

        let crop = SKCropNode()
        crop.name = ObjectNames.eyeCrop
        let mask = SKShapeNode(circleOfRadius: 45)
        mask.fillColor = .white
        mask.strokeColor = .clear
        crop.maskNode = mask
        crop.addChild(eye)
        addChild(crop)

//        let outline = SKShapeNode(circleOfRadius: 45)
//        outline.name = ObjectNames.cropOutline
//        outline.strokeColor = .red
//        outline.lineWidth = 1
//        outline.fillColor = .clear
//        outline.zPosition = Layer.Relative.above
//        addChild(outline)

        let moveRight = SKAction.group([
            .moveTo(
                x: 150,
                duration: 1.5
            ),
            .scaleX(
                to: 1,
                duration: 0.15
            )
        ])
        let moveLeft = SKAction.group([
            .moveTo(
                x: -150,
                duration: 1.5
            ),
            .scaleX(
                to: -1,
                duration: 0.15
            )
        ])
        let move = SKAction.sequence([moveRight, moveLeft])
        eye.run(
            .repeatForever(move),
            withKey: Constants.moveEyeThroughMask
        )
    }
}

private enum Constants {
    static let moveEyeThroughMask = "moveEyeThroughMask"
}
