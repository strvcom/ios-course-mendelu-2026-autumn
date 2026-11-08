//
//  BinaryFloatingPoint+Extension.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.09.2022.
//

extension BinaryFloatingPoint {
    /// Normalizes given value.
    ///
    /// You have 2 set boundaries, which are `min` and `max` and output of this
    /// function will return value between `from` and `to`. For example, if you
    /// set `from` to 0 and `to` to `1`, return of this function will be some value
    /// between 0 and 1.
    func normalize(
        min: Self,
        max: Self,
        from a: Self = 0,
        to b: Self = 1
    ) -> Self {
        // Map the input to a 0...1 fraction, then scale it into the output range.
        (b - a) * ((self - min) / (max - min)) + a
    }
}
