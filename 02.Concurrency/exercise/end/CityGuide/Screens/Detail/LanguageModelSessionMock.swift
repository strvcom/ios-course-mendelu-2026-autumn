//
//  LanguageModelSessionMock.swift
//  CityGuide
//

import Foundation

/// Stand-in for `LanguageModelSession` that returns a hardcoded answer.
final class LanguageModelSessionMock {

    let response: String
    /// Pause between streamed snapshots, zero keeps tests fast.
    let streamDelay: Duration = .milliseconds(300)

    init(
        instructions: String,
        response: String = "Welcome to Brno. You'll notice the grandeur of the Baroque style in the intricate details of Sample MENDELU's facade. Pair your visit with a light jacket, perfect for the current max temperature of 13.1°C."
    ) {
        self.response = response
    }

    /// Returns the whole hardcoded text at once.
    func respond(to prompt: String) async throws -> String {
        response
    }

    /// Streams the hardcoded text word by word.
    /// Like the real session, every snapshot contains the whole text generated so far.
    func streamResponse(to prompt: String) -> AsyncThrowingStream<String, Error> {
        let words = response.split(separator: " ")
        let delay = streamDelay

        return AsyncThrowingStream { continuation in
            let task = Task {
//            Task {
                var snapshot = ""
                for word in words {
                    if Task.isCancelled {
                        break
                    }

                    snapshot += snapshot.isEmpty ? String(word) : " \(word)"
                    continuation.yield(snapshot)
                    try? await Task.sleep(for: delay)
                    print(snapshot)
                }
                continuation.finish()
            }
            // stop producing when the consumer stops listening
            continuation.onTermination = { _ in task.cancel() }
        }
    }
}
