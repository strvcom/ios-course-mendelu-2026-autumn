//
//  Joystick.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.09.2022.
//

import SpriteKit

final class Joystick: SKSpriteNode {
    // MARK: Properties
    /// Joystick background, the black circle which is not moving.
    private var backgroundNode: SKSpriteNode?
    /// Moving part of joystick (orange circle).
    private var knobNode: SKSpriteNode?
    /// Stored keys, which users holds down.
    private var pressedKeys = Set<String>()

    /// Edges, which indicates max `x` position of `knobNode`
    private var positionTresholds: EdgePositions {
        // Limit the knob to half the joystick width on either side of its center.
        let halfOfJoystickWidth = joystickSize.width / 2

        // We always use default joystick position, so that we have
        // same edge positions at any point in time.
        return EdgePositions(
            max: defaultPosition.x + halfOfJoystickWidth,
            min: defaultPosition.x - halfOfJoystickWidth
        )
    }

    /// Default position of `backgroundNode` and `knobNobe`, returns center in `Joystick` node.
    private var defaultPosition: CGPoint {
        CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )
    }

    private let joystickSize = CGSize(size: 64)

    /// Normalized value between -1 ... 1.
    private(set) var velocity: CGFloat = 0

    // MARK: Overrides
    override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let touch = touches.first else {
            return
        }

        let touchLocation = touch.location(in: self).x

        // We have to restrict knobXPositon to EdgePositions, otherwise, we
        // would be able to move it out of bounds.
        let knobXPosition = touchLocation.clamped(to: positionTresholds.min ... positionTresholds.max)

        updateKnobXPosition(knobXPosition: knobXPosition)
    }

    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        resetKnobNodePosition()
    }

    override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        resetKnobNodePosition()
    }
}

// MARK: GameObject
extension Joystick: SceneObject {
    func setup(scene: LevelScene) {
        size = CGSize(
            width: joystickSize.width + 2 * 72,
            height: joystickSize.height + 2 * 36
        )
        anchorPoint = .zero
        zPosition = Layer.controls

        scene.cameraObject.addChild(self)

        isUserInteractionEnabled = true

        let bottomLeft = scene.cameraObject.bottomLeftCorner

        position = CGPoint(
            x: bottomLeft.x,
            y: bottomLeft.y
        )

        backgroundNode = SKSpriteNode(imageNamed: Assets.Image.joystickBackground)
        // We increased background size a little, so that it's clearly
        // visible at all times.
        backgroundNode?.size = joystickSize + 4
        backgroundNode?.zPosition = zPosition
        backgroundNode?.position = defaultPosition

        addOptionalChild(backgroundNode)

        knobNode = SKSpriteNode(imageNamed: Assets.Image.joystickKnob)
        knobNode?.position = defaultPosition
        // We want to have knobNode always above backgroundNode
        knobNode?.zPosition = zPosition + Layer.Relative.above
        knobNode?.size = joystickSize

        addOptionalChild(knobNode)
    }

    func keyboardUp(presses: Set<UIPress>) {
        // Storing right and left arrow in pressedKeys set.
        for press in presses {
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                pressedKeys.insert(UIKeyCommand.inputLeftArrow)
            }

            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                pressedKeys.insert(UIKeyCommand.inputRightArrow)
            }
        }

        updateKnobXPositionKeyboardAfterPress()
    }

    func keyboardDown(presses: Set<UIPress>) {
        // Removing right and left arrow from pressedKeys set.
        for press in presses {
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                pressedKeys.remove(UIKeyCommand.inputLeftArrow)
            }

            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                pressedKeys.remove(UIKeyCommand.inputRightArrow)
            }
        }

        updateKnobXPositionKeyboardAfterPress()
    }
}

// MARK: EdgePositions
private extension Joystick {
    struct EdgePositions {
        let max: CGFloat
        let min: CGFloat
    }
}

// MARK: Private API
private extension Joystick {
    /// Updates knob position after using keyboard.
    func updateKnobXPositionKeyboardAfterPress() {
        var knobXPosition = defaultPosition.x

        // We set knob position either to max or min treshold,
        // according which keys are contained in pressedKeys
        for key in pressedKeys {
            if key == UIKeyCommand.inputLeftArrow {
                knobXPosition = positionTresholds.min
            }

            if key == UIKeyCommand.inputRightArrow {
                knobXPosition = positionTresholds.max
            }
        }

        updateKnobXPosition(knobXPosition: knobXPosition)
    }

    /// Updates `knobNode` position in parent.
    func updateKnobXPosition(knobXPosition: CGFloat) {
        // We are updaring only x position, since we want to move joystick
        // only to left and right.
        knobNode?.position = CGPoint(
            x: knobXPosition,
            y: defaultPosition.y
        )

        // After knob is moved, we can take its position and normalize it to
        // velocity value, so that velocity is always in range between -1 and 1.
        velocity = knobXPosition.normalize(
            min: positionTresholds.min,
            max: positionTresholds.max,
            from: -1,
            to: 1
        )
    }

    /// Resets knob position.
    ///
    /// When knob position is reseting, we are not able to interact with it.
    func resetKnobNodePosition() {
        isUserInteractionEnabled = false

        velocity = 0

        let moveAction = SKAction.move(
            to: defaultPosition,
            duration: 0.1
        )
        moveAction.timingMode = .easeInEaseOut

        knobNode?.run(moveAction) { [weak self] in
            self?.isUserInteractionEnabled = true
        }
    }
}
