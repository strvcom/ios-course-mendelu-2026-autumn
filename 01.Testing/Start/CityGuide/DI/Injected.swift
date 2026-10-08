//
//  Injected.swift
//  CityGuide
//
//  Created by David Prochazka on 18.03.2025.
//

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T

    init() {
        wrappedValue = DIContainer.shared.resolve()
    }
}
