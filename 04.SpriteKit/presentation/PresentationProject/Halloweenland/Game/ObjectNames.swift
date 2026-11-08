//
//  ObjectNames.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 30.09.2022.
//

/// Names of objects in scene.
///
/// When you assign `name` to `SKNode`, you can easily find it with
/// function [childNode(withName: String)](https://developer.apple.com/documentation/spritekit/sknode/1483060-childnode)
/// on `SKNode` object.
enum ObjectNames {
    static let ground = "Ground"
    static let scenery = "Scenery"
    static let player = "Player"
    static let tile = "Tile"
    static let door = "Door"
    static let projectile = "Projectile"
    static let fountain = "Fountain"
    static let start = "Start"
    static let back = "back"
    static let zombieCounter = "zombieCounter"
    static let eyeArtwork = "eyeArtwork"
    static let attractionField = "attractionField"
    static let eyeCrop = "eyeCrop"
    static let cropOutline = "cropOutline"
    static let movingEye = "movingEye"
    static let eyeParticles = "eyeParticles"
    static let ghostLight = "ghostLight"
    static let blurEffect = "blurEffect"
}
