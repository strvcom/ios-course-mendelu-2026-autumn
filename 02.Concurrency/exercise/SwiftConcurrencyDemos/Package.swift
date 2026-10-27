// swift-tools-version: 6.2
// Tools version 6.x => every target is compiled in the Swift 6 language mode,
// so data races are compile-time ERRORS, not warnings.

import PackageDescription

/// Part of Xcode's "Approachable Concurrency" build setting:
/// a plain `async` function runs on the caller's actor; use `@concurrent` to go to the background.
let approachableAsync: [SwiftSetting] = [
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
]

let package = Package(
    name: "SwiftConcurrencyDemos",
    platforms: [.macOS(.v15), .iOS(.v26)],
    targets: [
        // Small utilities used by the demos: printThread(), measure(), startHeartbeat().
        .target(
            name: "Helpers",
            swiftSettings: approachableAsync
        ),

        // Demos 1–5. Nothing runs on the main actor unless we say so.
        .target(
            name: "Demos",
            dependencies: ["Helpers"],
            swiftSettings: approachableAsync
        ),

        // Demo 6. Same settings as a NEW app project created in Xcode 26+:
        // Default Actor Isolation = MainActor, Approachable Concurrency = Yes.
        .target(
            name: "ApproachableDemos",
            dependencies: ["Helpers"],
            swiftSettings: approachableAsync + [
                .defaultIsolation(MainActor.self),
                .enableUpcomingFeature("InferIsolatedConformances"),
            ]
        ),
    ]
)
