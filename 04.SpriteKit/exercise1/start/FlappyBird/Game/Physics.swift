//
//  Physics.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 28.11.2023.
//

enum Physics {}

extension Physics {
    enum CategoryBitMask {
        static let environment: UInt32 = 0b1
        static let player: UInt32 = 0b10
        static let spaceBetweenPipes: UInt32 = 0b100
    }
}

extension Physics {
    enum CollisionBitMask {
        static let environment = Physics.CategoryBitMask.player
        static let player = Physics.CategoryBitMask.environment
    }
}

extension Physics {
    enum ContactTestBitMask {
        static let environment = Physics.CategoryBitMask.player
        static let player = Physics.CategoryBitMask.environment
            | Physics.CategoryBitMask.spaceBetweenPipes
        static let spaceBetweenPipes = Physics.CategoryBitMask.player
    }
}
