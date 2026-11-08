//
//  Player.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import SpriteKit
import GameplayKit

final class Player: SKSpriteNode {
    // MARK: Static
    static let playerLifes = 3

    // MARK: Private Properties
    private let idleFrames = SKTextureAtlas(named: Assets.Atlas.playerIdle).textures
    private let walkingFrames = SKTextureAtlas(named: Assets.Atlas.playerWalk).textures
    private let attackFrames = SKTextureAtlas(named: Assets.Atlas.playerAttack).textures
    private let deathFrames = SKTextureAtlas(named: Assets.Atlas.playerDeath).textures
    weak var grabbedRope: Rope?
    private var isJumping: Bool { movementStateMachine.isInState(JumpingState.self) }
    private var isAttacking: Bool { stateMachine.isInState(AttackingState.self) }
    private var isHurt: Bool { damageStateMachine.isInState(HurtState.self) }
    private var previousUpdateTime: TimeInterval?

    private var lifes: Int = Player.playerLifes {
        didSet {
            levelScene?.playerLifes.hearts[max(
                0,
                lifes
            )].alpha = 0.5
        }
    }

    /// Hutbox positioned to player hand when attacking.
    private lazy var hurtBox: HurtBox = {
        HurtBox(
            size: CGSize(
                width: 5,
                height: 5
            ),
            position: CGPoint(
                x: 10,
                y: 4
            )
        )
    }()

    /// Direction, where player is facing towards.
    private var direction: Direction = .right {
        didSet {
            guard oldValue != direction else {
                return
            }

            updateNodeDirection(direction: direction)
        }
    }

    private var velocity: CGFloat {
        levelScene?.joystick.velocity ?? 0
    }

    private var isWalking: Bool {
        velocity != 0
    }

    private var isDead: Bool {
        stateMachine.isInState(DeadState.self)
    }
    private lazy var stateMachine = GKStateMachine(states: [
        IdleState(player: self),
        WalkingState(player: self),
        AttackingState(player: self),
        DeadState(player: self)
    ])
    // Jumping and invulnerability can overlap with attack and animation states.
    private lazy var movementStateMachine: GKStateMachine = {
        let machine = GKStateMachine(states: [GroundedState(player: self), JumpingState(player: self)])
        machine.enter(GroundedState.self)
        return machine
    }()
    private lazy var damageStateMachine: GKStateMachine = {
        let machine = GKStateMachine(states: [VulnerableState(), HurtState(player: self)])
        machine.enter(VulnerableState.self)
        return machine
    }()
    private lazy var stateMachines = [movementStateMachine, stateMachine, damageStateMachine]

    private(set) var animations = [String: SKAction]()

    /// Hitbox positioned to player physics body.
    private(set) lazy var hitbox: HitBox = {
        HitBox(
            size: CGSize(
                width: 20,
                height: 35
            ),
            position: CGPoint(
                x: 0,
                y: -2
            )
        )
    }()
}

// MARK: Gameplay states
private extension Player {
    class PlayerState: GKState {
        weak var player: Player?

        init(player: Player) {
            self.player = player
            super.init()
        }
    }
    final class IdleState: PlayerState {
        override func didEnter(from previousState: GKState?) {
            player?.playAnimation(key: Constants.Animations.idle.rawValue)
        }

        override func update(deltaTime seconds: TimeInterval) {
            guard
                let player,
                player.isWalking
            else {
                return
            }
            stateMachine?.enter(WalkingState.self)
        }
    }
    final class WalkingState: PlayerState {
        override func didEnter(from previousState: GKState?) {
            player?.playAnimation(key: Constants.Animations.walking.rawValue)
        }

        override func update(deltaTime seconds: TimeInterval) {
            guard
                let player,
                !player.isWalking
            else {
                return
            }
            stateMachine?.enter(IdleState.self)
        }
    }
    final class AttackingState: PlayerState {
        override func didEnter(from previousState: GKState?) {
            player?.playAnimation(key: Constants.Animations.attacking.rawValue)
        }

        override func update(deltaTime seconds: TimeInterval) {
            player?.updateHurtBox()
        }
    }
    // Horizontal movement is shared by both grounded and airborne players.
    class MovementState: PlayerState {
        override func update(deltaTime seconds: TimeInterval) {
            guard
                let player,
                !player.isDead
            else {
                return
            }
            player.updateDirection()
            player.updatePosition()
        }
    }
    final class GroundedState: MovementState {}
    final class JumpingState: MovementState {}
    final class VulnerableState: GKState {}
    final class HurtState: PlayerState {
        private var timeRemaining: TimeInterval = 0

        override func didEnter(from previousState: GKState?) {
            timeRemaining = 1.5
            player?.run(
                .sequence([
                    .fadeIn(withDuration: 0.1),
                    .fadeOut(withDuration: 0.1),
                    .fadeIn(withDuration: 0.1),
                    .fadeOut(withDuration: 0.1),
                    .fadeIn(withDuration: 0.1)
                ]),
                withKey: Constants.hurtBlink
            )
        }

        override func update(deltaTime seconds: TimeInterval) {
            timeRemaining -= seconds
            if timeRemaining <= 0 {
                stateMachine?.enter(VulnerableState.self)
            }
        }

        override func willExit(to nextState: GKState) {
            player?.removeAction(forKey: Constants.hurtBlink)
            player?.alpha = 1
        }
    }
    final class DeadState: PlayerState {
        override func didEnter(from previousState: GKState?) {
            player?.hurtBox.removeFromParent()
            player?.playAnimation(key: Constants.Animations.death.rawValue)
        }

        override func isValidNextState(_ stateClass: AnyClass) -> Bool { false }
    }
}

// MARK: AnimatedObject
extension Player: AnimatedObject {}

// MARK: GameObject
extension Player: SceneObject {
    func setup(scene: LevelScene) {
        setupActions()
        _ = stateMachine.enter(IdleState.self)
        previousUpdateTime = nil
        setupPlayer()
    }

    func update(_ currentTime: TimeInterval) {
        // SpriteKit supplies an absolute timestamp; GameplayKit expects elapsed time.
        let deltaTime = previousUpdateTime.map { max(
            0,
            min(
                currentTime - $0,
                0.1
            )
        ) } ?? 0
        previousUpdateTime = currentTime
        stateMachines.update(deltaTime: deltaTime)
    }

    func handleContactStart(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == self {
            handleContactWith(
                body: contact.bodyB,
                contact: contact
            )
        } else if contact.bodyB.node == self {
            handleContactWith(
                body: contact.bodyA,
                contact: contact
            )
        }
    }
}

// MARK: Public API
extension Player {
    func attack() {
        guard !isAttacking else {
            return
        }

        guard !isDead else {
            return
        }
        _ = stateMachine.enter(AttackingState.self)
    }

    func jump() {
        guard !isDead else {
            return
        }
        if let rope = grabbedRope {
            rope.releasePlayer()
            grabbedRope = nil
            _ = movementStateMachine.enter(JumpingState.self)
            physicsBody?.applyImpulse(CGVector(
                dx: 0,
                dy: size.height * 0.7
            ))
            return
        }
        // We can jump only when isJumping is set to false, otherwise we would
        // be able to jump in the air.
        guard !isJumping else {
            return
        }

        _ = movementStateMachine.enter(JumpingState.self)

        physicsBody?.applyImpulse(
            CGVector(
                dx: 0,
                dy: size.height * 0.7
            )
        )
    }

    func hit() {
        guard
            !isHurt,
            !isDead
        else {
            return
        }

        lifes -= 1

        if lifes <= 0 {
            _ = stateMachine.enter(DeadState.self)
        } else {
            _ = damageStateMachine.enter(HurtState.self)
        }
    }
}

// MARK: Private API
private extension Player {
    func setupPlayer() {
        addChild(hitbox)

        zPosition = Layer.characters

        physicsBody = SKPhysicsBody(
            texture: SKTexture(imageNamed: Assets.Image.playerPhysicsBody),
            // Physics body has same size as hitbox.
            size: hitbox.size
        )

        physicsBody?.categoryBitMask = Physics.CategoryBitMask.player
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.player
        physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.player
        physicsBody?.fieldBitMask = Physics.FieldBitMask.player
        // Prevents boucing when coliding with some other object.
        physicsBody?.restitution = 0
        // If allowsRotatin would be true, than there is a possibility that node
        // could fall to one side.
        physicsBody?.allowsRotation = false
    }

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

        animations[Constants.Animations.death.rawValue] = SKAction.group([
            SKAction.run { [weak self] in
                // We set physicsBody to nil, because we don't want player to
                // be able to interact with other objects in physics world
                // upon death.
                self?.grabbedRope?.releasePlayer()
                self?.grabbedRope = nil
                self?.physicsBody = nil
            },
            SKAction.animate(
                with: deathFrames,
                timePerFrame: 0.5,
                resize: true,
                restore: true
            ),
            SKAction.sequence([
                SKAction.wait(forDuration: 0.5 * Double(deathFrames.count)),
                SKAction.run { [weak self] in
                    guard let self = self else {
                        return
                    }

                    self.levelScene?.playerDied()
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

    func updateDirection() {
        if velocity > 0 {
            direction = .right
        } else if velocity < 0 {
            direction = .left
        }
    }

    func updatePosition() {
        if grabbedRope != nil {
            // While attached, joystick input applies force to swing the rope.
            physicsBody?.applyForce(CGVector(
                dx: velocity * 35,
                dy: 0
            ))
            return
        }

        // Scale horizontal movement by sprite width and joystick direction.
        let moveBy = size.width * 0.2 * velocity

        position = CGPoint(
            x: position.x + moveBy,
            y: position.y
        )
    }

    /// Evaluates, if `hurtbox` hitted something.
    func updateHurtBox() {
        guard
            // Only evaluate, when hurbox is actually visible.
            hurtBox.parent != nil,
            let levelScene = levelScene
        else {
            return
        }

        for zombie in levelScene.zombies {
            guard hurtBox.intersects(zombie.hitBox) else {
                continue
            }

            zombie.hit()
        }
    }

    func handleContactWith(
        body: SKPhysicsBody,
        contact: SKPhysicsContact
    ) {
        switch body.node?.name {
        case ObjectNames.tile:
            // Contactnormal > 0 indicates that player hit the ground with legs.
            guard contact.contactNormal.dy > 0 else {
                return
            }

            _ = movementStateMachine.enter(GroundedState.self)
        case ObjectNames.door:
            guard let door = body.node as? Door else {
                return
            }

            door.entered()
            levelScene?.playerEnteredDoor()
        default:
            break
        }
    }
}

private enum Constants {
    enum Animations: String {
        case walking
        case idle
        case attacking
        case death
    }
    static let hurtBlink = "hurtBlink"
}
