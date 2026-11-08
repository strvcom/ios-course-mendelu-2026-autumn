//
//  Assets.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 29.09.2022.
//

enum Assets {}

// MARK: Image
extension Assets {
    enum Image {
        static let background1 = "Background/b1"
        static let background2 = "Background/b2"
        static let background3 = "Background/b3"
        static let background4 = "Background/b4"
        static let welcomeBackground = "Background/background"
        static let projectile = "PumpkinProjectile"
        static let attackButton = "Controls/AttackButton"
        static let jumpButton = "Controls/JumpButton"
        static let joystickBackground = "Controls/JoystickBackground"
        static let joystickKnob = "Controls/JoystickKnob"
        static let playerPhysicsBody = "PlayerPhysicsBody"
        static let brownEye = "Scenery/Spooky/eye_brown"
        static let greenEye = "Scenery/Spooky/eye_green"
        static let ghost = "Scenery/Spooky/ghost"
        static let spark = "spark"
        static let playerLife = "Scenery/Heart/heart"
        static let closedDoor = "ClosedDoor"
        static let openedDoor = "OpenedDoor"
    }
}

// MARK: Atlas
extension Assets {
    enum Atlas {
        static let playerIdle = "PlayerIdle"
        static let playerWalk = "PlayerWalk"
        static let playerAttack = "PlayerAttack"
        static let playerDeath = "PlayerDeath"
        static let zombieIdle = "ZombieIdle"
        static let zombieWalk = "ZombieWalk"
        static let zombieDeath = "ZombieDeath"
        static let zombieAttack = "ZombieAttack"
        static let pumpkinEating = "PumpkinEating"
        static let doorOpening = "DoorOpening"
        static let playerEnteringDoor = "PlayerEntering"
        static let fountainFlowing = "FountainFlowing"
    }
}

// MARK: Scenes
extension Assets {
    enum Scenes {
        static let welcomeScreen = "WelcomeScreen"
        static let levels = ["Level1", "Level2"]
        static let levelCompleted = "LevelCompleted"
        static let gameOver = "GameOver"
    }
}

// MARK: Emitters
extension Assets {
    enum Emitter {
        static let eyeParticles = "EyeParticles.sks"
    }
}
