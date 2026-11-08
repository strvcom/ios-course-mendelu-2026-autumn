//
//  CGSize+Extension.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.10.2022.
//

import CoreGraphics

extension CGSize {
    /// Operator which enable us to use '+' between `CGSize`.
    static func + (
        left: CGSize,
        right: CGFloat
    ) -> CGSize {
        CGSize(
            width: left.width + right,
            height: left.height + right
        )
    }

    /// Init with `width` and `height` to same value.
    init(size: CGFloat) {
        self.init(
            width: size,
            height: size
        )
    }
}
