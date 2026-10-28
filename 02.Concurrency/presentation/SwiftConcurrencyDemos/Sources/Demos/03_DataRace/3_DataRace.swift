import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 3 · Data race
//
// 100 000 child tasks all increment one shared counter at the same time.
// The same loop comes back in Demo 4 (actor) and Demo 5 (Mutex).

///// A plain class with mutable state. NOT safe to share between threads.
/// Swift 6 refuses to compile it unless we conform it to `@unchecked Sendable` to *promise* the compiler it is thread-safe.
final class UnsafeCounter: @unchecked Sendable {
    var value = 0
    func increment() { value += 1 }
}

#Playground("3 · The data race at runtime") {
    let counter = UnsafeCounter()

    await withTaskGroup(of: Void.self) { group in
        for _ in 1...100_000 {
            group.addTask { counter.increment() }
        }
    }

    // Less than 100 000, and different on every run.
    print("Expected 100000, got \(counter.value)")
}
