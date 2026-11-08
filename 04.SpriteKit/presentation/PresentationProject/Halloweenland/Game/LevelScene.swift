//
//  LevelScene.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import SpriteKit

/// Delegate to comunicate, when the player finishes the level.
protocol LevelSceneDelegate: AnyObject {
    func levelSceneLevelCompleted()
    func levelSceneLevelFailed(sceneImage: UIImage)
}

/// Scene, where the game is played. It passes values to all `SceneObjects`, handles
/// physics contants and communicates with `GameViewController`.
final class LevelScene: SKScene {
    // MARK: Properties
    weak var levelSceneDelegate: LevelSceneDelegate?

    var allSceneObjects: [SceneObject] {
        [
            cameraObject,
            background,
            level,
            player,
            joystick,
            controlButtons,
            playerLifes
        ]
            + zombies
            + others
    }

    // We are using force unwrapping here, which is not good practice,
    // so we have to make sure, that all SceneObjects are initialized
    // before we are working with them. The initialisation is done in
    // didMove(to view: SKView) function.
    private(set) var cameraObject: Camera!
    private(set) var background: Background!
    private(set) var level: Level!
    private(set) var player: Player!
    private(set) var joystick: Joystick!
    private(set) var controlButtons: ControlButtons!
    private(set) var playerLifes: PlayerLifes!
    private(set) var zombies = [Zombie]()
    private(set) var others = [SceneObject]()
    /// Indicates whether player is eligible to complete the level succesfully
    /// and is based on conditions player must comply to to succeed.
    /// For example player must kill all Zombies and only then is eligible to complete the level.
    var levelCanBeCompleted: Bool { zombies.isEmpty }

    // MARK: Overrides
    override func willMove(from view: SKView) {
        super.willMove(from: view)

        // Setting scale mode so that objects in scene are sized correctly.
        scaleMode = .aspectFill
    }

    /// We have to ensure that all objects are initialized here, before we start using them.
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self

        // Some objects are initialized directly, because they are not located
        // in sks file.
        cameraObject = Camera()

        background = Background()

        joystick = Joystick()

        controlButtons = ControlButtons()

        playerLifes = PlayerLifes()

        // Other objets are found in sks file and initialized
        // according correct downcasting.
        for child in children {
            switch child {
            case let zombie as Zombie:
                zombies.append(zombie)
            case let map as SKTileMapNode:
                level = Level(ground: map)
            case let player as Player:
                self.player = player
            case let other as SceneObject:
                others.append(other)
            default:
                break
            }
        }

        // After everything is initialized, we can safely start
        // calling functions on SceneObjects.
        allSceneObjects.forEach { $0.setup(scene: self) }
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        allSceneObjects.forEach { $0.update(currentTime) }
    }
}

// MARK: SKPhysicsContactDelegate
extension LevelScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        allSceneObjects.forEach { $0.handleContactStart(contact) }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        allSceneObjects.forEach { $0.handleContactEnd(contact) }
    }
}

// MARK: Public API
extension LevelScene {
    /// Removes zombie from `zombies` array.
    func zombieDied(zombie: Zombie) {
        guard let index = zombies.firstIndex(where: { $0 === zombie }) else {
            return
        }

        zombies.remove(at: index)
        playerLifes.updateZombieCount(zombies.count)
    }

    func playerEnteredDoor() {
        player.isPaused = true
        player.alpha = 0

        levelSceneDelegate?.levelSceneLevelCompleted()
    }

    func playerDied() {
        guard let levelSceneScreenshot = makeScreenshot() else {
            return
        }

        levelSceneDelegate?.levelSceneLevelFailed(sceneImage: levelSceneScreenshot)
    }
}

// MARK: Private API
private extension LevelScene {
    /// Creates screenshot from current view and returns it as `UIImage`.
    func makeScreenshot() -> UIImage? {
        let snapshotView = view?.snapshotView(afterScreenUpdates: true)
        let bounds = UIScreen.main.bounds

        UIGraphicsBeginImageContextWithOptions(
            bounds.size,
            false,
            0
        )
        snapshotView?.drawHierarchy(
            in: bounds,
            afterScreenUpdates: true
        )
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return screenshotImage
    }
}
