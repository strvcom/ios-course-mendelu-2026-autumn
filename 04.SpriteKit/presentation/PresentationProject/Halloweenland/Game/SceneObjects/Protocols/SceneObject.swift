//
//  GameObject.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import UIKit
import SpriteKit

/// Protocol representating object in scene. Every method is optional, you can implement only those
/// you need to.
protocol SceneObject {
    /// Called one, after every scene object is initialized. You can perform custom setup or add another child nodes here.
    func setup(scene: LevelScene)

    /// Function, which is called every frame.
    func update(_ currentTime: TimeInterval)

    /// Called, when the user presses key on keyboard, only for simulator debug purposes.
    func keyboardDown(presses: Set<UIPress>)

    /// Called, when the user lifts the finger from key on keyboard, only for simulator debug purposes.
    func keyboardUp(presses: Set<UIPress>)

    /// Called, when some contact in scene was detected.
    func handleContactStart(_ contact: SKPhysicsContact)

    /// Called, when object in scene lost contact.
    func handleContactEnd(_ contact: SKPhysicsContact)
}

// MARK: Default Implementation
extension SceneObject {
    func setup(scene: LevelScene) {}

    func update(_ currentTime: TimeInterval) {}

    func keyboardDown(presses: Set<UIPress>) {}

    func keyboardUp(presses: Set<UIPress>) {}

    func handleContactStart(_ contact: SKPhysicsContact) {}

    func handleContactEnd(_ contact: SKPhysicsContact) {}
}

// MARK: SceneObject + SKNode
extension SceneObject where Self: SKNode {
    /// Returns downcasted level scene.
    var levelScene: LevelScene? {
        scene as? LevelScene
    }
}
