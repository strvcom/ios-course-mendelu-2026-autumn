import SpriteKit
import CoreImage

/// A floating ghost that alternates between a sharp and a blurred appearance.
final class BlurryGhost: SKSpriteNode {}

extension BlurryGhost: SceneObject {
    func setup(scene: LevelScene) {
        let ghostTexture = SKTexture(imageNamed: Assets.Image.ghost)
        if size == .zero { size = ghostTexture.size() }
        texture = nil
        anchorPoint = CGPoint(
            x: 0.5,
            y: 0.5
        )
        zPosition = Layer.scenery

        childNode(withName: ObjectNames.blurEffect)?.removeFromParent()
        let effect = SKEffectNode()
        effect.name = ObjectNames.blurEffect
        effect.filter = CIFilter(
            name: Constants.gaussianBlurFilter,
            parameters: [kCIInputRadiusKey: 0]
        )
        effect.shouldEnableEffects = true
        effect.addChild(SKSpriteNode(
            texture: ghostTexture,
            size: size
        ))
        addChild(effect)

        let duration: TimeInterval = 2
        let maximumRadius: CGFloat = 5
        // Convert elapsed time into a 0...1 fraction to interpolate the blur radius.
        let blur = SKAction.customAction(withDuration: duration) { node, elapsed in
            (node as? SKEffectNode)?.filter?.setValue(
                maximumRadius * elapsed / CGFloat(duration),
                forKey: kCIInputRadiusKey
            )
        }
        let sharpen = SKAction.customAction(withDuration: duration) { node, elapsed in
            (node as? SKEffectNode)?.filter?.setValue(
                maximumRadius * (1 - elapsed / CGFloat(duration)),
                forKey: kCIInputRadiusKey
            )
        }
        effect.run(
            .repeatForever(.sequence([blur, sharpen])),
            withKey: Constants.alternateBlur
        )

        // Scale the floating distance with the sprite and return to its starting point.
        let offset = size.height * 0.2
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
    static let alternateBlur = "alternateBlur"

    static let ghostFloat = "ghostFloat"

    static let gaussianBlurFilter = "CIGaussianBlur"
}
