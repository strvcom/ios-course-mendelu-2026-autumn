//
//  Zombie.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 01.10.2022.
//

import SpriteKit
import GameplayKit

final class Zombie: SKSpriteNode {
    // MARK: Properties
    private let idleFrames = SKTextureAtlas(named: Assets.Atlas.zombieIdle).textures
    private var walkingFrames = SKTextureAtlas(named: Assets.Atlas.zombieWalk).textures
    private var attackFrames = SKTextureAtlas(named: Assets.Atlas.zombieAttack).textures
    private var deathFrames = SKTextureAtlas(named: Assets.Atlas.zombieDeath).textures
    /// Same as `Joystick` velocity, indicates, how fast and where is zombie moving.
    private var velocity: CGFloat = 0
    private lazy var stateMachine = GKStateMachine(states: [
        IdleState(zombie: self),
        WalkingState(zombie: self),
        AttackingState(zombie: self),
        DeadState(zombie: self)
    ])
    private var isDead: Bool { stateMachine.isInState(DeadState.self) }
    private var isAttacking: Bool { stateMachine.isInState(AttackingState.self) }
    private var previousUpdateTime: TimeInterval?

    /// Hutbox positioned to zombie hands when attacking.
    private lazy var hurtBox: HurtBox = {
        HurtBox(
            size: CGSize(
                width: 6,
                height: 6
            ),
            position: CGPoint(
                x: 8,
                y: 4
            )
        )
    }()

    /// Direction, where zombie is facing towards.
    private var direction: Direction = .right {
        didSet {
            guard oldValue != direction else {
                return
            }

            updateNodeDirection(direction: direction)
        }
    }

    private var isWalking: Bool {
        velocity != 0
    }

    private(set) var animations = [String: SKAction]()

    /// Hitbox positioned to zombie physics body.
    private(set) lazy var hitBox: HitBox = {
        HitBox(
            size: CGSize(
                width: 18,
                height: 35
            ),
            position: CGPoint(
                x: -3,
                y: 0
            )
        )
    }()
}

// MARK: Gameplay states
private extension Zombie {
    class ZombieState: GKState {
        weak var zombie: Zombie?

        init(zombie: Zombie) {
            self.zombie = zombie
            super.init()
        }
    }

    // Idle and walking use the same player detection and pursuit logic.
    class PursuingState: ZombieState {
        override func update(deltaTime seconds: TimeInterval) {
            guard
                let zombie,
                let stateMachine
            else {
                return
            }
            guard zombie.canSeePlayer() else {
                zombie.velocity = 0
                if !stateMachine.isInState(IdleState.self) {
                    stateMachine.enter(IdleState.self)
                }
                return
            }

            zombie.updateDirection()
            zombie.updatePosition()

            if zombie.distanceToPlayer < zombie.size.width / 2 {
                stateMachine.enter(AttackingState.self)
            } else if zombie.isWalking,
                      !stateMachine.isInState(WalkingState.self) {
                stateMachine.enter(WalkingState.self)
            } else if !zombie.isWalking,
                      !stateMachine.isInState(IdleState.self) {
                stateMachine.enter(IdleState.self)
            }
        }
    }

    final class IdleState: PursuingState {
        override func didEnter(from previousState: GKState?) {
            zombie?.playAnimation(key: Constants.Animations.idle.rawValue)
        }
    }
    final class WalkingState: PursuingState {
        override func didEnter(from previousState: GKState?) {
            zombie?.playAnimation(key: Constants.Animations.walking.rawValue)
        }
    }
    final class AttackingState: ZombieState {
        override func didEnter(from previousState: GKState?) {
            zombie?.playAnimation(key: Constants.Animations.attacking.rawValue)
        }

        override func update(deltaTime seconds: TimeInterval) {
            guard let zombie else {
                return
            }
            guard zombie.canSeePlayer() else {
                zombie.velocity = 0
                return
            }
            zombie.updateHurtBox()
        }
    }
    final class DeadState: ZombieState {
        override func didEnter(from previousState: GKState?) {
            zombie?.hurtBox.removeFromParent()
            zombie?.playAnimation(key: Constants.Animations.death.rawValue)
        }

        override func isValidNextState(_ stateClass: AnyClass) -> Bool { false }
    }
}

// MARK: GameObject
extension Zombie: SceneObject {
    func setup(scene: LevelScene) {
        setupActions()
        _ = stateMachine.enter(IdleState.self)
        previousUpdateTime = nil

        setupZombie()

    }

    func update(_ currentTime: TimeInterval) {
        let deltaTime = previousUpdateTime.map { max(
            0,
            min(
                currentTime - $0,
                0.1
            )
        ) } ?? 0
        previousUpdateTime = currentTime
        stateMachine.update(deltaTime: deltaTime)
    }
}

// MARK: PlayerReactiveObject
extension Zombie: PlayerObservingObject {}

// MARK: AnimatedObject
extension Zombie: AnimatedObject {}

// MARK: Zombie
extension Zombie {
    /// Call, when zombie should be hit by something. Zombie has only one life, so
    /// he dies immediatelly after one hit.
    func hit() {
        guard !isDead else {
            return
        }

        _ = stateMachine.enter(DeadState.self)
    }
}

// MARK: Private API
private extension Zombie {
    func setupActions() {
        animations[Constants.Animations.idle.rawValue] = SKAction.repeatForever(
            SKAction.animate(
                with: idleFrames,
                timePerFrame: 0.2,
                resize: false,
                restore: true
            )
        )

        animations[Constants.Animations.walking.rawValue] = SKAction.repeatForever(
            SKAction.animate(
                with: walkingFrames,
                timePerFrame: 0.2,
                resize: false,
                restore: true
            )
        )

        let deathTimePerFrame: TimeInterval = 0.3

        animations[Constants.Animations.death.rawValue] = SKAction.group([
            SKAction.run { [weak self] in
                // We set physicsBody to nil, because we don't want zombie to
                // be able to interact with other objects in physics world
                // upon death.
                self?.physicsBody = nil
            },
            SKAction.animate(
                with: deathFrames,
                timePerFrame: deathTimePerFrame,
                resize: true,
                restore: true
            ),
            SKAction.sequence([
                SKAction.wait(forDuration: deathTimePerFrame * Double(deathFrames.count)),
                SKAction.run { [weak self] in
                    guard let self = self else {
                        return
                    }

                    self.levelScene?.zombieDied(zombie: self)

                    self.removeFromParent()
                }
            ])
        ])

        let attackTimePerFrame: TimeInterval = 0.08

        animations[Constants.Animations.attacking.rawValue] = SKAction.group([
            SKAction.animate(
                with: attackFrames,
                timePerFrame: attackTimePerFrame,
                resize: false,
                restore: true
            ),
            // Hurbox is only going to be shown between 4th and last frame.
            SKAction.sequence([
                SKAction.wait(forDuration: attackTimePerFrame * Double(4)),
                SKAction.run { [weak self] in
                    guard let self = self else {
                        return
                    }

                    self.addChild(self.hurtBox)
                },
                SKAction.wait(forDuration: attackTimePerFrame * Double(2)),
                SKAction.run { [weak self] in
                    self?.hurtBox.removeFromParent()
                    guard let self = self else {
                        return
                    }
                    _ = self.stateMachine.enter(self.isWalking ? WalkingState.self : IdleState.self)
                }
            ])
        ])
    }

    func setupZombie() {
        zPosition = Layer.characters

        physicsBody = SKPhysicsBody(
            rectangleOf: hitBox.size,
            center: hitBox.position
        )
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.zombie
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.zombie
        // Prevents boucing when coliding with some other object.
        physicsBody?.restitution = 0
        // If allowsRotatin would be true, than there is a possibility that node
        // could fall to one side.
        physicsBody?.allowsRotation = false

        addChild(hitBox)
    }

    /// The first body along the ray must be the player for the zombie to see them.
    func canSeePlayer() -> Bool {
        guard let body = levelScene?.physicsWorld.body(
            alongRayStart: position,
            end: playerPosition
        ) else {
            return false
        }
        return body.categoryBitMask == Physics.CategoryBitMask.player
    }

    /// Updates zombie direction to face player.
    func updateDirection() {
        guard
            !isDead,
            !isAttacking
        else {
            return
        }

        direction = playerPosition.x > position.x
            ? .right
            : .left
    }

    /// Updates zombie position to walk to player.
    func updatePosition() {
        guard
            !isDead,
            !isAttacking
        else {
            return
        }

        // When player is far, zombie is too lazy to go, he waits until
        // there is player close enough.
        if distanceToPlayer > 200 {
            velocity = 0
        } else {
            // After player moved closer, zombie starts to walk towards him / her.
            velocity = playerPosition.x > position.x
                ? 1
                : -1
        }

        // Calculated zombie speed.
        // Scale horizontal movement by sprite width and direction.
        let moveBy = size.width * 0.07 * velocity

        position = CGPoint(
            x: position.x + moveBy,
            y: position.y
        )
    }

    /// Evaluates, if `hurtbox` hitted something.
    func updateHurtBox() {
        guard
            hurtBox.parent != nil,
            let levelScene = levelScene
        else {
            return
        }

        guard
            let player = levelScene.player,
            hurtBox.intersects(player.hitbox)
        else {
            return
        }

        levelScene.player.hit()
    }
}

private enum Constants {
    enum Animations: String {
        case walking
        case idle
        case death
        case attacking
    }
}
