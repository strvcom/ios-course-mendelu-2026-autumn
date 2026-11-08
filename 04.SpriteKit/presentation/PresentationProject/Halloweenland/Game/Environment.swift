//
//  Environment.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 02.10.2022.
//

import Foundation

/// Values used to enable debug options.
enum Environment {
    /// Shows hitboxes (blue) and hurboxes (red) when the value is `true`.
    static let showHitboxesAndHurtBoxes = false
    /// Show multiple things on scene, when set to `true`.
    ///
    /// The concrete list is:
    /// - shows FPS in bottom right corner
    /// - shows node count in bottom right corner
    /// - shows green block around physics bodies
    static let sceneInDebugMode = false
}
