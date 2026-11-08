//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 14.11.2023.
//

import UIKit
import SpriteKit

final class GameViewController: UIViewController {
    private var skView: SKView {
        view as! SKView
    }
    
    override func loadView() {
        view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView.showsPhysics = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        skView.presentScene(
            GameScene(
                size: CGSize(
                    width: 288,
                    height: 512
                )
            )
        )
    }
}
