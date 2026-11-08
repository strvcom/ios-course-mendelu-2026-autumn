import SpriteKit

/// Place this sprite at the rope's ceiling attachment point in the scene editor.
final class Rope: SKSpriteNode {
    private let segmentCount = 7
    private let segmentLength: CGFloat = 20
    private var tip: SKShapeNode?
    private var playerJoint: SKPhysicsJointPin?
    private var canGrab = true

    func releasePlayer() {
        guard
            let joint = playerJoint,
            let scene = scene
        else {
            return
        }
        scene.physicsWorld.remove(joint)
        playerJoint = nil

        // Give the player time to move away before another grab is allowed.
        canGrab = false
        run(
            .sequence([
                .wait(forDuration: 0.8),
                .run { [weak self] in self?.canGrab = true }
            ]),
            withKey: Constants.ropeGrabCooldown
        )
    }
}

extension Rope: SceneObject {
    func setup(scene: LevelScene) {
        physicsBody = nil
        texture = nil
        color = .clear
        anchorPoint = CGPoint(
            x: 0.5,
            y: 0.5
        )
        zPosition = Layer.world

        let anchor = SKNode()
        anchor.physicsBody = SKPhysicsBody(circleOfRadius: 2)
        anchor.physicsBody?.isDynamic = false
        anchor.physicsBody?.categoryBitMask = Physics.none
        anchor.physicsBody?.collisionBitMask = Physics.CollisionBitMask.rope
        addChild(anchor)

        // Each segment is a separate body, connected at its end by a pin joint.
        var previousBody = anchor.physicsBody!
        for index in 0..<segmentCount {
            let segment = SKSpriteNode(
                color: .brown,
                size: CGSize(
                    width: 6,
                    height: segmentLength
                )
            )
            // Place each segment below the previous one, with its center halfway down.
            segment.position = CGPoint(
                x: 0,
                y: -(CGFloat(index) + 0.5) * segmentLength
            )
            let body = SKPhysicsBody(rectangleOf: segment.size)
            body.categoryBitMask = Physics.none
            body.collisionBitMask = Physics.CollisionBitMask.rope
            body.contactTestBitMask = Physics.none
            body.fieldBitMask = Physics.FieldBitMask.rope
            body.linearDamping = 0.1
            body.angularDamping = 0.1
            segment.physicsBody = body
            addChild(segment)

            // Connect the top of this segment to the preceding body.
            let jointPosition = CGPoint(
                x: 0,
                y: -CGFloat(index) * segmentLength
            )
            let pin = SKPhysicsJointPin.joint(
                withBodyA: previousBody,
                bodyB: body,
                anchor: convert(
                    jointPosition,
                    to: scene
                )
            )
            scene.physicsWorld.add(pin)
            previousBody = body
        }

        let tip = SKShapeNode(circleOfRadius: 5)
        tip.fillColor = .brown
        tip.strokeColor = .clear
        tip.position = CGPoint(
            x: 0,
            y: -CGFloat(segmentCount) * segmentLength
        )
        let tipBody = SKPhysicsBody(circleOfRadius: 10)
        tipBody.categoryBitMask = Physics.CategoryBitMask.rope
        tipBody.collisionBitMask = Physics.CollisionBitMask.rope
        tipBody.contactTestBitMask = Physics.ContactTestBitMask.rope
        tipBody.fieldBitMask = Physics.FieldBitMask.rope
        tip.physicsBody = tipBody
        addChild(tip)
        self.tip = tip

        // Keep the handle fixed to the last segment; the other pins let the rope bend.
        scene.physicsWorld.add(SKPhysicsJointFixed.joint(
            withBodyA: previousBody,
            bodyB: tipBody,
            anchor: convert(
                tip.position,
                to: scene
            )
        ))
    }

    func handleContactStart(_ contact: SKPhysicsContact) {
        guard
            canGrab,
            playerJoint == nil,
            let tip = tip,
            let scene = levelScene
        else {
            return
        }
        let otherBody: SKPhysicsBody
        if contact.bodyA.node === tip {
            otherBody = contact.bodyB
        } else if contact.bodyB.node === tip {
            otherBody = contact.bodyA
        } else {
            return
        }
        guard let player = otherBody.node as? Player else {
            return
        }

        // Add joints outside the physics contact callback.
        run(.run { [weak self, weak player, weak scene] in
            guard
                let self,
                let player,
                let scene,
                self.canGrab,
                self.playerJoint == nil,
                player.grabbedRope == nil,
                let tipBody = self.tip?.physicsBody,
                let playerBody = player.physicsBody,
                let tip = self.tip,
                player.scene === scene
            else {
                return
            }
            let endPoint = tip.convert(
                CGPoint.zero,
                to: scene
            )
            // Align the player’s top edge with the rope tip.
            let playerPoint = CGPoint(
                x: endPoint.x,
                y: endPoint.y - player.size.height / 2
            )
            guard let parent = player.parent else {
                return
            }
            player.position = parent.convert(
                playerPoint,
                from: scene
            )
            playerBody.velocity = tipBody.velocity
            let joint = SKPhysicsJointPin.joint(
                withBodyA: tipBody,
                bodyB: playerBody,
                anchor: endPoint
            )
            scene.physicsWorld.add(joint)
            self.playerJoint = joint
            player.grabbedRope = self
        })
    }
}

private enum Constants {
    static let ropeGrabCooldown = "ropeGrabCooldown"
}
