//
//  Assets.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SpriteKit

enum Assets {}

// MARK: Textures
extension Assets {
    enum Textures {
        static let background = "background"
        static let pipe = "pipe"
        static let base = "base"
        static let bird = "bird"
        static let getReady = "getReady"
    }
}

// MARK: Sounds
extension Assets {
    enum Sounds {
        static let hit = "hit.wav"
        static let point = "point.wav"
        static let wing = "wing.wav"
    }
}

// MARK: Fonts
extension Assets {
    enum Fonts {
        static let flappy = "04b_19"
    }
}
