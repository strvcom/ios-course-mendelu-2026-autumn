import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 4a · An actor fixes the data race

/// An actor protects its mutable state: only one task at a time can run inside it.
actor Counter {
    var value = 0

    func increment() {
        value += 1 // inside the actor: plain synchronous code, no await
    }
}

#Playground("4a · An actor fixes the data race") {
    let counter = Counter()

    await withTaskGroup(of: Void.self) { group in
        for _ in 1...100_000 {
            group.addTask { await counter.increment() } // outside the actor: await
        }
    }

    print("Expected 100000, got \(await counter.value)")
}
