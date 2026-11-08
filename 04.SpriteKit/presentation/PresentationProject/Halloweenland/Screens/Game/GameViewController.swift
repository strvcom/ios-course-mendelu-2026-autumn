//
//  GameViewController.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import UIKit
import SpriteKit

final class GameViewController: UIViewController {
    // MARK: Properties
    private var currentLevelIndex = 0

    private var skView: SKView {
        view as! SKView
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    // MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        skView.showsFPS = Environment.sceneInDebugMode
        skView.showsNodeCount = Environment.sceneInDebugMode
        skView.ignoresSiblingOrder = true
        skView.preferredFramesPerSecond = 30
        skView.showsPhysics = Environment.sceneInDebugMode
        skView.isMultipleTouchEnabled = true

        welcomeScreen()
    }

    /// React to presses began and passes them to `LevelScene`. We found out, when you
    /// override methods in `SKNode`, it doesn't always work.
    override func pressesBegan(
        _ presses: Set<UIPress>,
        with event: UIPressesEvent?
    ) {
        super.pressesBegan(
            presses,
            with: event
        )

        guard let scene = skView.scene as? LevelScene else {
            return
        }

        for gameObject in scene.allSceneObjects {
            gameObject.keyboardUp(presses: presses)
        }
    }

    /// React to presses ended and passes them to `LevelScene`. We found out, when you
    /// override methods in `SKNode`, it doesn't always work.
    override func pressesEnded(
        _ presses: Set<UIPress>,
        with event: UIPressesEvent?
    ) {
        super.pressesEnded(
            presses,
            with: event
        )

        guard let scene = skView.scene as? LevelScene else {
            return
        }

        for gameObject in scene.allSceneObjects {
            gameObject.keyboardDown(presses: presses)
        }
    }

    /// Presents `WelcomeScreen` in `skView`.
    func welcomeScreen() {
        guard let scene = WelcomeScreen(fileNamed: Assets.Scenes.welcomeScreen) else {
            return
        }

        scene.welcomeScreenDelegate = self
        scene.scaleMode = .aspectFill

        let transition = SKTransition.crossFade(withDuration: 0.6)

        skView.presentScene(
            scene,
            transition: transition
        )
    }

    /// Presents `LevelScene` in `skView`.
    func startGame() {
        currentLevelIndex = 0
        presentCurrentLevel()
    }

    private func presentCurrentLevel() {
        guard let scene = LevelScene(fileNamed: Assets.Scenes.levels[currentLevelIndex]) else {
            return
        }

        scene.levelSceneDelegate = self

        let transition = SKTransition.crossFade(withDuration: 0.6)

        skView.presentScene(
            scene,
            transition: transition
        )
    }

    /// Presents `LevelFinishedScene` in `skView`.
    func showLevelFinishedScene(
        sceneFileName: String,
        backgroundImage: UIImage
    ) {
        guard let scene = LevelFinishedScene(fileNamed: sceneFileName) else {
            return
        }

        scene.setBackgroundImage(backgroundImage)
        scene.levelFinishedSceneDelegate = self
        scene.scaleMode = .aspectFill

        let transition = SKTransition.crossFade(withDuration: 1)

        skView.presentScene(
            scene,
            transition: transition
        )
    }
}

// MARK: LevelCompletionDelegate
extension GameViewController: LevelSceneDelegate {
    func levelSceneLevelCompleted() {
        guard currentLevelIndex + 1 < Assets.Scenes.levels.count else {
            return
        }

        currentLevelIndex += 1
        presentCurrentLevel()
    }

    func levelSceneLevelFailed(sceneImage: UIImage) {
        showLevelFinishedScene(
            sceneFileName: Assets.Scenes.gameOver,
            backgroundImage: sceneImage
        )
    }
}

// MARK: WelcomeScreenDelegate
extension GameViewController: WelcomeScreenDelegate {
    func welcomeScreenNewGameButtonTapped() {
        startGame()
    }
}

extension GameViewController: LevelFinishedSceneDelegate {
    func levelFinishedSceneNewGameButtonTapped() {
        startGame()
    }
}
