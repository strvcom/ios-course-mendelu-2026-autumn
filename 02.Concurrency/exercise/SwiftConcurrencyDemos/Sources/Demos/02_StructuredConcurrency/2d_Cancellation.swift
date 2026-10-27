import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 2d · Cancellation is cooperative

/// Long-running work that cooperates with cancellation.
func processPhotos() async throws {
    for photo in 1...10 {
        try Task.checkCancellation() // throws CancellationError once the task is cancelled
        print("Processing photo \(photo)")
        try await Task.sleep(for: .seconds(1)) // Task.sleep checks cancellation too
    }
}

#Playground("2d · Cancellation is cooperative") {
    let task = Task {
        do {
            try await processPhotos()
            print("✅ All photos processed")
        } catch {
            print("🛑 Stopped: \(error)")
        }
    }

    try await Task.sleep(for: .seconds(1))
    task.cancel() // only sets a flag – the task has to check it
    await task.value
}
