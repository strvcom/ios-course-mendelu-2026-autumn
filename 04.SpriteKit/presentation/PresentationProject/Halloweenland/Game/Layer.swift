//
//  Layer.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import UIKit

/// Drawing depths in the scene. Nodes with a higher effective z position appear in front.
/// A child's effective position includes the z positions of its ancestors.
enum Layer {
    // The background artwork is made of four overlapping images.
    static let background1: CGFloat = 0
    static let background2: CGFloat = 1
    static let background3: CGFloat = 2
    static let background4: CGFloat = 3

    static let scenery: CGFloat = 10
    static let world: CGFloat = 11
    static let characters: CGFloat = 12
    static let particles: CGFloat = 12.5
    static let foreground: CGFloat = 13
    static let controls: CGFloat = 20
    // Preserve the crop example's placement above the rest of the scene.
    static let overlay: CGFloat = 200

    /// Offsets for child nodes, relative to their parent's z position.
    enum Relative {
        static let behind: CGFloat = -1
        static let same: CGFloat = 0
        static let above: CGFloat = 1
        static let furtherAbove: CGFloat = 2
    }
}
