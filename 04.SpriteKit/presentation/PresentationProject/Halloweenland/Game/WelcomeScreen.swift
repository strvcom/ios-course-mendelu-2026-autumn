//
//  WelcomeScreen.swift
//  MendeluSpriteKit
//
//  Created by Raul Batista on 08.11.2022.
//

import Foundation
import SpriteKit

protocol WelcomeScreenDelegate: AnyObject {
    func welcomeScreenNewGameButtonTapped()
}

final class WelcomeScreen: SKScene {
    // MARK: Properties
    private var startButton: TouchNode?

    weak var welcomeScreenDelegate: WelcomeScreenDelegate?
}

// MARK: Public API
extension WelcomeScreen {
    override func didMove(to view: SKView) {
        startButton = childNode(withName: ObjectNames.start) as? TouchNode
        startButton?.tapAction = { [weak self] in
            self?.welcomeScreenDelegate?.welcomeScreenNewGameButtonTapped()
        }

        if let welcomeBackground = UIImage(named: Assets.Image.welcomeBackground) {
            setBackgroundImage(welcomeBackground)
        }
    }

    private func setBackgroundImage(_ image: UIImage) {
        let background = SKSpriteNode(texture: SKTexture(image: image))
        // Preserve the image’s aspect ratio while matching the scene width.
        let aspectRatio = image.size.height / image.size.width
        let backgroundSize = CGSize(
            width: size.width,
            height: size.width * aspectRatio
        )

        background.size = backgroundSize
        background.zPosition = Layer.Relative.behind
        background.alpha = 1

        addChild(background)
    }
}
