import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 1b · async ≠ background thread

/// A plain async function runs wherever it was called from.
func loadProfile() async throws {
    printThread("loadProfile – before await")
    try await Task.sleep(for: .milliseconds(100)) // ⏸ suspension point
    printThread("loadProfile – after await")
}

/// `@concurrent` = always run on the background thread pool.
@concurrent
func resizePhotos() async throws {
    printThread("resizePhotos – before await")
    try await Task.sleep(for: .milliseconds(100)) // ⏸ suspension point
    printThread("resizePhotos – after await") // can resume on a different thread!

    // Uncomment to see that loadProfile is going to execute on the same thread as the last printed one.
//    try await loadProfile()
}

#Playground("1b · async ≠ background thread") {
    printThread("playground") // #Playground code runs on the main actor
    try await loadProfile()
    try await resizePhotos()
    // Uncomment to see that loadProfile() is going to execute on main thread again.
//    try await loadProfile()
}
