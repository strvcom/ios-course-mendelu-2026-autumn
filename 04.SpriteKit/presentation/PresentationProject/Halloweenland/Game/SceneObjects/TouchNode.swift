//
//  TouchNode.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 12.10.2022.
//

import SpriteKit

/// Node, which can react to touches. When user lifts finger from it, `tapAction` is going to be called.
final class TouchNode: SKSpriteNode {
    // MARK: Properties
    var tapAction: (() -> Void)?

    override var isUserInteractionEnabled: Bool {
        set { }
        get { true }
    }

    // MARK: Overrides
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        run(
            SKAction.fadeAlpha(
                to: 0.5,
                duration: 0.2
            )
        )
    }

    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        run(
            SKAction.fadeAlpha(
                to: 1,
                duration: 0.01
            )
        )

        tapAction?()
    }
}
