//
//  Layer.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 28.11.2023.
//

/// Definition of the Z position of the objects, which means depth of the objects in scene.
/// `SKNodes` with higher value are going to overlap the nodes with smaller one.
enum Layer {
    static let background: Double = 0
    static let base: Double = 2
    static let pipe: Double = 1
    static let player: Double = 3
}
