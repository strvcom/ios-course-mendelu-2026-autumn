//
//  Comparable+Extension.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.09.2022.
//

extension Comparable {
    /// Clamps value in given range.
    ///
    /// For example, if you had number 50 and `range` parameter would be `0 ... 20`,
    /// result of this function will be 20, which is upper bound of given range. The sme principle
    /// applies in lower bound. When the value is in given `range`, this function will return
    /// the same value.
    func clamped(to range: ClosedRange<Self>) -> Self {
        max(
            range.lowerBound,
            min(
                self,
                range.upperBound
            )
        )
    }
}
