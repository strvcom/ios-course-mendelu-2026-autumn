import Foundation
import Helpers
import Playgrounds
import Synchronization

// MARK: - DEMO 5b · A Sendable class with a Mutex

/// Mutable state guarded by a Mutex (Synchronization, iOS 18+ / macOS 15+).
/// The compiler can verify this one – no @unchecked needed.
final class MutexCounter: Sendable {
    private let value = Mutex(0)

    func increment() { value.withLock { $0 += 1 } }
    var current: Int { value.withLock { $0 } }
}

#Playground("5b · A Sendable class with a Mutex") {
    let counter = MutexCounter()

    await withTaskGroup(of: Void.self) { group in
        for _ in 1...100_000 {
            group.addTask { counter.increment() } // no await – a Mutex is synchronous
        }
    }

    print("Expected 100000, got \(counter.current)")
}
