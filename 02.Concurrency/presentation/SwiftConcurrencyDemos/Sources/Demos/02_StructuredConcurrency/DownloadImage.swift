import Foundation
import Helpers

// MARK: - Used by Demos 2a–2c

/// Pretends to download an image: takes 1 second, but doesn't block any thread.
func downloadImage(_ id: Int) async throws -> String {
    try await Task.sleep(for: .seconds(1))
    printThread("image \(id)")
    return "🖼️\(id)"
}
