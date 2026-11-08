//
//  Door.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 05.10.2022.
//

import SpriteKit
import GameplayKit

final class Door: SKSpriteNode {
    // MARK: Properties
    private let openingDoorFrames = SKTextureAtlas(named: Assets.Atlas.doorOpening).textures
    private let playerEnteringDoorFrames = SKTextureAtlas(named: Assets.Atlas.playerEnteringDoor).textures
    private lazy var stateMachine = GKStateMachine(states: [ClosedState(), OpenState(), EnteredState()])
    private var isOpen: Bool { stateMachine.currentState is OpenState }

    private var isUnlocked: Bool {
        levelScene?.levelCanBeCompleted ?? false
    }

    private lazy var collisionPhysicsBody: SKPhysicsBody = {
        let physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: 10,
                height: 10
            ),
            center: CGPoint(
                x: -size.width / 4,
                y: 0
            )
        )
        physicsBody.categoryBitMask = Physics.CategoryBitMask.door
        physicsBody.affectedByGravity = false
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.isDynamic = false
        physicsBody.restitution = 0
        return physicsBody
    }()

    private(set) var animations = [String: SKAction]()
}

// MARK: Door states
private extension Door {
    final class ClosedState: GKState {}
    final class OpenState: GKState {}
    final class EnteredState: GKState {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { false }
    }
}

// MARK: Game Object
extension Door: SceneObject {
    func setup(scene: LevelScene) {
        _ = stateMachine.enter(ClosedState.self)
        setupDoor()

        setupActions()
    }

    func update(_ currentTime: TimeInterval) {
        updateState()
    }
}

// MARK: PlayerReactiveObject
extension Door: PlayerObservingObject {}

// MARK: AnimatedObject
extension Door: AnimatedObject {}

// MARK: Door public API
extension Door {
    func entered() {
        guard !(stateMachine.currentState is EnteredState) else {
            return
        }
        _ = stateMachine.enter(EnteredState.self)
        playAnimation(key: Constants.Animations.enter.rawValue)

        run(
            SKAction.fadeAlpha(
                to: 0,
                duration: 1
            )
        )
    }
}

// MARK: Private API
private extension Door {
    func setupDoor() {
        zPosition = Layer.world

        texture = openingDoorFrames.first

        name = ObjectNames.door
    }

    func setupActions() {
        let frameTimeInterval: TimeInterval = 0.08

        animations[Constants.Animations.open.rawValue] = SKAction.animate(
            with: openingDoorFrames,
            timePerFrame: frameTimeInterval,
            resize: false,
            restore: false
        )

        animations[Constants.Animations.close.rawValue] = SKAction.animate(
            with: openingDoorFrames.reversed(),
            timePerFrame: frameTimeInterval,
            resize: false,
            restore: false
        )

        animations[Constants.Animations.enter.rawValue] = SKAction.animate(
            with: playerEnteringDoorFrames,
            timePerFrame: 0.2,
            resize: false,
            restore: false
        )
    }

    func updateState() {
        let distanceToPlayerToOpenTheDoor: CGFloat = 80

        // When player is close enough and doors are unlocked (all zombies
        // are dead), we play opening door animation.
        switch distanceToPlayer {
        case let distance where distance <= distanceToPlayerToOpenTheDoor:
            guard
                !isOpen,
                !(stateMachine.currentState is EnteredState),
                isUnlocked
            else {
                return
            }

            playAnimation(key: Constants.Animations.open.rawValue)

            _ = stateMachine.enter(OpenState.self)

            // We set physics body to door, only when then can be opened, otherwise
            // player wouldn't be able to walk in front of them.
            guard physicsBody == nil else {
                return
            }

            physicsBody = collisionPhysicsBody

        // When player is too far, doors are going to be closed.
        case let distance where distance > distanceToPlayerToOpenTheDoor:
            guard isOpen else {
                return
            }

            playAnimation(key: Constants.Animations.close.rawValue)

            _ = stateMachine.enter(ClosedState.self)
        default:
            break
        }
    }
}

private enum Constants {
    enum Animations: String {
        /// Player comes to close proximity.
        case open
        /// Player leaves close proximity.
        case close
        /// Player enters the door.
        case enter
    }
}
