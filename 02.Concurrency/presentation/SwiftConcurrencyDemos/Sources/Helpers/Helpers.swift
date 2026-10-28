import Foundation

/// Prints whether the current code runs on the main thread or on a background thread.
///
/// `Thread.current` is unavailable inside `async` functions,
/// so the check lives in this small synchronous helper.
public func printThread(_ label: String) {
    if Thread.isMainThread {
        print("🟢 \(label) → main thread")
    } else {
        print("🔵 \(label) → background thread \(threadNumber())")
    }
}

/// "<NSThread: 0x…>{number = 7, name = (null)}" → "#7"
private func threadNumber() -> String {
    guard let match = Thread.current.description.firstMatch(of: /number = (\d+)/) else { return "" }
    return "#\(match.1)"
}

/// Runs `operation` and prints how long it took.
@discardableResult
public func measure<T>(_ label: String, _ operation: () async throws -> T) async rethrows -> T {
    let start = ContinuousClock.now
    let result = try await operation()
    let elapsed = (ContinuousClock.now - start).components
    let seconds = Double(elapsed.seconds) + Double(elapsed.attoseconds) / 1e18
    print("⏱️ \(label): \(String(format: "%.2f", seconds)) s")
    return result
}

/// Prints a 💓 every 0.25 s for as long as the main thread is free.
/// When the heartbeats stop, something is blocking the main thread – in an app, the UI would freeze.
@MainActor
public func startHeartbeat() -> Task<Void, Never> {
    Task {
        while !Task.isCancelled {
            print("   💓")
            try? await Task.sleep(for: .milliseconds(250))
        }
    }
}
