import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 4e · @MainActor view model
/// Pretends to download an image: takes 1 second, but doesn't block any thread.
func downloadGalleryImage(_ id: Int) async throws -> String {
    try await Task.sleep(for: .seconds(1))
    printThread("image \(id)")
    return "🖼️\(id)"
}

/// A view model: everything here runs on the main actor, so it can safely drive the UI.
@MainActor
final class GalleryViewModel {
    private(set) var images: [String] = []

    func load() async {
        printThread("load() – start")
        let image = try? await downloadGalleryImage(7) // ⏸ main thread is free while we wait
        printThread("load() – after await") // back on the main actor → safe to update UI state
        images.append(image ?? "❌")
    }
}

#Playground("4e · @MainActor view model") {
    let viewModel = GalleryViewModel()
    await viewModel.load()
    print(viewModel.images)
}
