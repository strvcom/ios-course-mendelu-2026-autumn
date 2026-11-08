//
//  Level.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 29.09.2022.
//

import SpriteKit

final class Level {
    // MARK: Properties
    /// `SKTileMapNode` which represents ground. It consits only from `Tiles`.
    let ground: SKTileMapNode

    // MARK: Init
    init(ground: SKTileMapNode) {
        self.ground = ground
    }
}

// MARK: GameObject
extension Level: SceneObject {
    func setup(scene: LevelScene) {
        ground.zPosition = Layer.world

        // When we find node, which is scenery, we are going to set
        // correct zPosition to it.
        for child in scene.children {
            guard child.name == ObjectNames.scenery else {
                continue
            }

            child.zPosition = Layer.scenery
        }

        addPhysicsToTileMapNodes(scene: scene)

        // Here, we are creating 4 invisible boundaries around SKTileMapNode,
        // which represents our level. The reason is that we don't want player
        // or any other thing to fall from boundary of level.
        // You can imagine this boundaries as very small invisible rectangles,
        // which are placed at top, left, right and bottom side of SKTileMapNode.

        createTopBoundary(scene: scene)

        createLeftBoundary(scene: scene)

        createRightBoundary(scene: scene)

        createBottomBoundary(scene: scene)
    }
}

// MARK: Private API
private extension Level {
    /// Adds physics to every tile node in scene.
    ///
    /// Due to spritekit limitations, we are not able to easily say, that each tile should have some kind of
    /// physics category, so we have to implement this functionality by ourselfs.
    func addPhysicsToTileMapNodes(scene: LevelScene) {
        // Because SKTileMapNode is basically grid, we can easily iterate
        // through every grid tiles.
        for columnNumber in 0 ..< ground.numberOfColumns {
            for rowNumber in 0 ..< ground.numberOfColumns {
                let definition = ground.tileDefinition(
                    atColumn: columnNumber,
                    row: rowNumber
                )

                // When tile definition is nil, it means that grid tile is empty,
                // which means it doesn't have texture, so we don't care about it.
                guard definition != nil else {
                    continue
                }

                // After finding out, that we are in grid tile, which has texture,
                // we are going to create SKNode, which has exast same size and
                // position as grid tile and enable physics on it.

                // Convert tile indices into positions in the map’s coordinate system.
                let xPosition = ground.tileSize.width * CGFloat(columnNumber)

                let yPosition = ground.tileSize.height * CGFloat(rowNumber)

                let node = SKSpriteNode(
                    color: .clear,
                    size: ground.tileSize
                )
                node.name = ObjectNames.tile
                node.zPosition = Layer.world
                node.position = CGPoint(
                    x: xPosition,
                    y: yPosition
                )
                node.anchorPoint = .zero
                node.physicsBody = SKPhysicsBody(
                    rectangleOf: ground.tileSize,
                    center: CGPoint(
                        x: ground.tileSize.width * 0.5,
                        y: ground.tileSize.height * 0.5
                    )
                )
                // Node is not dynamic, so it's not affected by physics and stays
                // at one place.
                node.physicsBody?.isDynamic = false
                node.physicsBody?.restitution = 0
                node.physicsBody?.categoryBitMask = Physics.CategoryBitMask.groundTile
                node.physicsBody?.collisionBitMask = Physics.CollisionBitMask.groundTile

                scene.addChild(node)
            }
        }
    }

    func createTopBoundary(scene: LevelScene) {
        let height: CGFloat = 1

        let width: CGFloat = scene.level.ground.mapSize.width

        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: 0,
                y: scene.level.ground.mapSize.height + height
            ),
            scene: scene
        )
    }

    func createLeftBoundary(scene: LevelScene) {
        let height = scene.level.ground.mapSize.height

        let width: CGFloat = 1

        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: -width,
                y: 0
            ),
            scene: scene
        )
    }

    func createRightBoundary(scene: LevelScene) {
        let height = scene.level.ground.mapSize.height

        let width: CGFloat = 1

        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: scene.level.ground.mapSize.width,
                y: 0
            ),
            scene: scene
        )
    }

    func createBottomBoundary(scene: LevelScene) {
        let height: CGFloat = 1

        let width: CGFloat = scene.level.ground.mapSize.width

        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: 0,
                y: -height
            ),
            scene: scene
        )
    }

    func createBoundarySprite(
        size: CGSize,
        position: CGPoint,
        scene: LevelScene
    ) {
        let node = SKSpriteNode(
            color: .clear,
            size: size
        )
        node.position = position
        node.anchorPoint = .zero
        node.physicsBody = SKPhysicsBody(
            rectangleOf: size,
            center: CGPoint(
                x: size.width * 0.5,
                y: size.height * 0.5
            )
        )
        // Node is not dynamic, so it's not affected by physics and stays
        // at one place.
        node.physicsBody?.isDynamic = false
        // Prevents boucing when coliding with some other object.
        node.physicsBody?.restitution = 0
        node.physicsBody?.categoryBitMask = Physics.CategoryBitMask.boundary
        node.physicsBody?.collisionBitMask = Physics.CollisionBitMask.boundary

        scene.addChild(node)
    }
}
