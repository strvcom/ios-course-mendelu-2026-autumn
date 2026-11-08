import SpriteKit

/// Attracts the player nearby and hurts them on contact.
final class EvilEye: SKSpriteNode {
    private weak var attractionField: SKFieldNode?
}

extension EvilEye: SceneObject {
    func setup(scene: LevelScene) {
        anchorPoint = CGPoint(
            x: 0.5,
            y: 0.5
        )

        let eyeTexture = SKTexture(imageNamed: Assets.Image.brownEye)
        if size == .zero { size = eyeTexture.size() }
        texture = nil
        zPosition = Layer.scenery

        childNode(withName: ObjectNames.eyeArtwork)?.removeFromParent()
        let eye = SKSpriteNode(
            texture: eyeTexture,
            size: size
        )
        eye.name = ObjectNames.eyeArtwork
        // Rotate only the artwork, keeping the field's coordinate system fixed.
        eye.constraints = [SKConstraint.orient(
            to: scene.player,
            offset: SKRange(constantValue: 0)
        )]
        addChild(eye)

        if physicsBody == nil {
            physicsBody = SKPhysicsBody(rectangleOf: size)
        }
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.evilEye
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.evilEye
        physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.evilEye

        childNode(withName: ObjectNames.attractionField)?.removeFromParent()
        let attractionField = SKFieldNode.radialGravityField()
        attractionField.name = ObjectNames.attractionField
        attractionField.strength = 5 // Positive strength pulls toward the field center.
        attractionField.falloff = 2
        attractionField.region = SKRegion(radius: 160)
        attractionField.categoryBitMask = Physics.FieldBitMask.evilEye
        attractionField.isEnabled = true
        addChild(attractionField)
        self.attractionField = attractionField
    }

    func handleContactStart(_ contact: SKPhysicsContact) {
        guard
            contact.bodyA.node == self ||
            contact.bodyB.node == self
        else {
            return
        }
        let otherBody = contact.bodyA.node == self ? contact.bodyB : contact.bodyA
        guard let player = otherBody.node as? Player else {
            return
        }
        player.hit()
        guard
            let attractionField,
            attractionField.isEnabled
        else {
            return
        }
        attractionField.isEnabled = false
        run(
            .sequence([
                .wait(forDuration: 3),
                .run { [weak attractionField] in attractionField?.isEnabled = true }
            ]),
            withKey: Constants.restoreAttractionField
        )
    }
}

private enum Constants {
    static let restoreAttractionField = "restoreAttractionField"
}
