import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 6a · Who is blocking the main thread?
//
// This target is built with the same settings as a NEW Xcode 26+ app project:
//   Default Actor Isolation  = MainActor  → everything below is @MainActor unless marked otherwise
//   Approachable Concurrency = Yes        → plain async functions run on the caller's actor

/// CPU-heavy work (~1 s). Nothing async here – it simply keeps its thread busy.
enum HeavyWork {
    /// `nonisolated`: not tied to the main actor, so it is allowed to run anywhere.
    nonisolated static let photos = ["🌄", "🏙️", "🌊"]

    nonisolated static func startOnMain() -> [String] {
        var checksum = 0
        for i in 0..<15_000_00 { checksum &+= i % 7 }
        return photos.map { "✨\($0)" }
    }

    @concurrent
    static func startOnBackground() async -> [String] {
        var checksum = 0
        for i in 0..<15_000_00 { checksum &+= i % 7 }
        return photos.map { "✨\($0)" }
    }
}

#Playground("6a · Who is blocking the main thread?") {
    let heartbeat = startHeartbeat() // 💓 only while the main thread is free

    try await Task.sleep(for: .seconds(1))

    print("start main actor work")
    await measure("main actor") { HeavyWork.startOnMain() } // no 💓 → frozen UI

    print("start concurrent work")
    await measure("@concurrent") { await HeavyWork.startOnBackground() } // 💓 keeps going

    heartbeat.cancel()
}
