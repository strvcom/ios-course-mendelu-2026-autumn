//
//  GameScene.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 28.11.2023.
//

import SpriteKit

final class GameScene: SKScene {
    private var player: PlayerNode!
    private var base: BaseNode!
    private var score = 0
    private var pipes: [PipeNode] {
        children.compactMap { $0 as? PipeNode }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        isPaused = true
        
        physicsWorld.contactDelegate = self
        
        base = BaseNode()
        
        let background = BackgroundNode()
        
        player = PlayerNode()
        
        let top = TopNode(width: size.width)
        
        addChild(top)
        addChild(player)
        addChild(base)
        addChild(background)
        
        background.anchorPoint = .zero
        
        base.anchorPoint = .zero
        base.position = CGPoint(
            x: 0,
            y: -base.size.height * 0.3
        )
        
        player.position = CGPoint(
            x: size.width * 0.5,
            y: size.height * 0.5
        )
        
        top.position = CGPoint(
            x: size.width * 0.5,
            y: size.height
        )
        
        spawnPipe()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        player.updateRotation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if isPaused {
            isPaused = false
        } else {
            player.flapWings()
        }        
    }
    
    func spawnPipe() {
        let spaceBetweenPipes = player.size.height * 4
        
        let lastPipeYPosition = pipes.last?.position.y ?? size.height * 0.5
        
        let randomOffset = CGFloat.random(in: -150 ... 150)
        
        let topYOffsetTreshold = size.height - spaceBetweenPipes * 0.5
        
        let bottomYOffsetTreshold = base.position.y + base.size.height + spaceBetweenPipes * 0.5
        
        let pipeYPosition: CGFloat = {
            let pipeYPosition = lastPipeYPosition + randomOffset
            
            if pipeYPosition > topYOffsetTreshold || pipeYPosition < bottomYOffsetTreshold {
                return lastPipeYPosition - randomOffset
            } else {
                return pipeYPosition
            }
        }()
        
        let pipe = PipeNode(spaceBetweenPipes: spaceBetweenPipes)
        pipe.position = CGPoint(
            x: size.width + pipe.width * 0.5,
            y: pipeYPosition
        )
        
        addChild(pipe)
        
        pipe.run(
            .group([
                .sequence([
                    .move(
                        to: CGPoint(
                            x: -pipe.width * 0.5,
                            y: pipeYPosition
                        ),
                        duration: 5
                    ),
                    .removeFromParent()
                ]),
                .sequence([
                    .wait(forDuration: 2.5),
                    .run { [weak self] in
                        self?.spawnPipe()
                    }
                ])
            ])
        )
    }
    
    func increaseScore(node: SKNode?) {
        guard let pipe = node?.parent as? PipeNode else {
            return
        }
        
        score += 1
        
        print("Score: \(score)")
        
        pipe.removeSpaceBetweenPipes()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let noPlayerBody = if contact.bodyA.node?.name == NodeName.player {
            contact.bodyB
        } else {
            contact.bodyA
        }
        
        switch noPlayerBody.node?.name {
        case NodeName.pipe, NodeName.base, NodeName.sceneBorder:
            // end game
            break
        case NodeName.spaceBetweenPipes:
            increaseScore(node: noPlayerBody.node)
        default:
            break
        }
    }
}
