//
//  LevelFinishedScene.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 12.10.2022.
//

import SpriteKit

protocol LevelFinishedSceneDelegate: AnyObject {
    func levelFinishedSceneNewGameButtonTapped()
}

final class LevelFinishedScene: SKScene {
    // MARK: Properties
    private var playAgainButton: TouchNode?

    weak var levelFinishedSceneDelegate: LevelFinishedSceneDelegate?
}

// MARK: Public API
extension LevelFinishedScene {
    override func didMove(to view: SKView) {
        backgroundColor = .black

        playAgainButton = children.first(where: { $0 is TouchNode }) as? TouchNode
        playAgainButton?.tapAction = { [weak self] in
            self?.levelFinishedSceneDelegate?.levelFinishedSceneNewGameButtonTapped()
        }
    }

    func setBackgroundImage(_ image: UIImage) {
        let background = SKSpriteNode(texture: SKTexture(image: image))
        // Preserve the image’s aspect ratio while matching the scene width.
        let aspectRatio = image.size.height / image.size.width
        let backgroundSize = CGSize(
            width: size.width,
            height: size.width * aspectRatio
        )

        background.size = backgroundSize
        background.zPosition = Layer.Relative.behind
        background.alpha = 0.3

        addChild(background)
    }
}
