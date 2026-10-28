import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 1c · AsyncSequence

/// Produces values over time. Consumed with `for await`.
func countdown(from start: Int) -> AsyncStream<Int> {
    AsyncStream { continuation in
        Task {
            for number in stride(from: start, through: 0, by: -1) {
                continuation.yield(number) // send a value to the `for await` loop
                try? await Task.sleep(for: .seconds(1))
            }
            continuation.finish() // ends the `for await` loop
        }
    }
}

#Playground("1c · AsyncSequence") {
    for await number in countdown(from: 3) {
        print(number > 0 ? "\(number)…" : "🚀 Liftoff!")
    }
}
