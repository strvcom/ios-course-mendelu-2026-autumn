//
//  ContolButtons.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 30.09.2022.
//

import SpriteKit

/// Buttons shown on bottom right side of the screen.
final class ControlButtons: SKSpriteNode {
    private var jumpButton: JumpButton!
    private var attackButton: AttackButton!

    private var center: CGPoint {
        CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )
    }

    // MARK: Overrides
    func keyboardUp(presses: Set<UIPress>) {
        jumpButton.keyboardUp(presses: presses)

        attackButton.keyboardUp(presses: presses)
    }
}
// MARK: GameObject
extension ControlButtons: SceneObject {
    func setup(scene: LevelScene) {
        scene.cameraObject.addChild(self)

        zPosition = Layer.controls
        anchorPoint = .zero

        let buttonSize: CGFloat = 72

        // To layout buttons, we are going to create size, which is equal
        // to grid of 9 buttons. Then, we are going to place jump and attack
        // buttons on 2 position on grid (J stands for jump button and A stands
        // for attack button).
        // xxx
        // xxA
        // xJx
        size = CGSize(
            width: 3 * buttonSize,
            height: 3 * buttonSize
        )
        position = CGPoint(
            // We are substracting controls size, since we want to move it to
            // left. If we didn't substract this value, controls would be rendered
            // outside of camera (on right).
            x: scene.cameraObject.bottomRightCorner.x - size.width - 16,
            y: scene.cameraObject.bottomRightCorner.y + 16
        )

        jumpButton = JumpButton(imageNamed: Assets.Image.jumpButton)
        jumpButton.size = CGSize(size: buttonSize)
        jumpButton.isUserInteractionEnabled = true
        // Jumpbutton position is in middle of bottom row in imaginary grid.
        jumpButton.position = CGPoint(
            x: center.x,
            y: center.y - buttonSize
        )

        addChild(jumpButton)

        attackButton = AttackButton(imageNamed: Assets.Image.attackButton)
        attackButton.size = CGSize(size: buttonSize)
        attackButton.isUserInteractionEnabled = true
        // Jumpbutton position is on the right side of middle row in imaginary grid.
        attackButton.position = CGPoint(
            x: center.x + buttonSize,
            y: center.y
        )

        addChild(attackButton)
    }
}

// MARK: JumpButton
final class JumpButton: SKSpriteNode {
    // MARK: JumpButton + Overrides
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        levelScene?.player.jump()
    }

    func keyboardUp(presses: Set<UIPress>) {
        for press in presses {
            // After space is pressed in keyboard, character is going to jump.
            if press.key?.charactersIgnoringModifiers == Constants.jumpKey {
                levelScene?.player.jump()
            }
        }
    }
}

// MARK: JumpButton + SceneObject
extension JumpButton: SceneObject {}

// MARK: AttackButton
final class AttackButton: SKSpriteNode {
    // MARK: AttackButton + Overrides
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        levelScene?.player.attack()
    }

    func keyboardUp(presses: Set<UIPress>) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == Constants.attackKey {
                levelScene?.player.attack()
            }
        }
    }
}

// MARK: AttackButton + SceneObject
extension AttackButton: SceneObject {}

private enum Constants {
    static let jumpKey = " "

    static let attackKey = "a"
}
