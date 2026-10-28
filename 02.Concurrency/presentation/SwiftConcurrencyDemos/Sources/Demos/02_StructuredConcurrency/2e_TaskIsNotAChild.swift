import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 2e · Task {} is NOT a child task

func work(_ name: String) async {
    do {
        try await Task.sleep(for: .seconds(2))
        print("✅ \(name) finished")
    } catch {
        print("🛑 \(name) was cancelled")
    }
}

#Playground("2e · Task {} is NOT a child task") {
    let parent = Task {
        async let child: Void = work("async let (child task)")
        let unstructured = Task { await work("Task {} (unstructured)") }

        await child
        await unstructured.value
    }

    parent.cancel() // cancels the child, but NOT the unstructured Task {}
    await parent.value
}
