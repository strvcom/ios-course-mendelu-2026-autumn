//
//  Physics.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

enum Physics {
    static let none: UInt32 = 0
    static let everyBitSet = UInt32.max
}

// MARK: CategoryBitMask
extension Physics {
    /// Defines what physics category the body belongs to.
    /// Every physics body in a scene can be assigned to up to 32 different categories,
    /// each corresponding to a bit in the bit mask. You define the mask values
    /// used in your game. In conjunction with the `collisionBitMask` and `contactTestBitMask`
    /// properties, you define which physics bodies interact with each other and when your
    /// game is notified of these interactions.
    enum CategoryBitMask {
        static let groundTile: UInt32 = 0b1
        static let boundary: UInt32 = 0b10
        static let player: UInt32 = 0b100
        static let zombie: UInt32 = 0b1000
        static let projectile: UInt32 = 0b1_0000
        static let door: UInt32 = 0b10_0000
        static let evilEye: UInt32 = 0b100_0000
        static let rope: UInt32 = 0b1000_0000
        // Reused by Lighting; physics, field and light masks are separate domains.
        static let ghost: UInt32 = 0b1_0000_0000
    }
}

// MARK: CollisionBitMask
extension Physics {
    /// A mask that defines which categories of physics bodies can collide with this physics body.
    /// When two physics bodies contact each other, a collision may occur.
    /// This body’s collision mask is compared to the other body’s category
    /// mask by performing a logical AND operation. If the result is a nonzero value,
    /// this body is affected by the collision.
    enum CollisionBitMask {
        static let projectile = Physics.everyBitSet
        static let player = Physics.CategoryBitMask.boundary |
            Physics.CategoryBitMask.zombie |
            Physics.CategoryBitMask.groundTile |
            Physics.CategoryBitMask.door |
            Physics.CategoryBitMask.evilEye
        static let zombie = Physics.CategoryBitMask.player |
            Physics.CategoryBitMask.groundTile |
            Physics.CategoryBitMask.boundary |
            Physics.CategoryBitMask.door
        static let evilEye = Physics.CategoryBitMask.player
        static let rope = Physics.none
        static let groundTile = Physics.CategoryBitMask.player |
            Physics.CategoryBitMask.zombie
        static let boundary = groundTile
    }
}

// MARK: ContactTestBitMask
extension Physics {
    /// A mask that defines which categories of physics bodies cause intersection
    /// notifications with this physics body. When two bodies share the same space,
    /// each body’s category mask is tested against the other body’s contact mask
    /// by performing a logical AND operation. If either comparison results
    /// in a nonzero value, an SKPhysicsContact object is created
    /// and passed to the physics world’s delegate.
    enum ContactTestBitMask {
        static let player = Physics.CategoryBitMask.groundTile |
            Physics.CategoryBitMask.evilEye
        static let evilEye = Physics.CategoryBitMask.player
        static let rope = Physics.CategoryBitMask.player
        static let projectile = Physics.everyBitSet
    }
}

// MARK: FieldBitMask
extension Physics {
    /// Field categories and physics body categories are independent masks.
    enum FieldBitMask {
        static let evilEye = CategoryBitMask.evilEye
        static let player = evilEye
        static let rope = Physics.none
    }
}
