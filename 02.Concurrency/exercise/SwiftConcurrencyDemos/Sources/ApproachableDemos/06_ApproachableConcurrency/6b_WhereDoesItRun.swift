import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 6b · Quiz: where does it run?
//
// This target is built with the same settings as a NEW Xcode 26+ app project:
//   Default Actor Isolation  = MainActor  → everything below is @MainActor unless marked otherwise
//   Approachable Concurrency = Yes        → plain async functions run on the caller's actor

func plainAsync() async {
    printThread("plainAsync()")
}

nonisolated func nonisolatedAsync() async {
    printThread("nonisolatedAsync()")
}

@concurrent
func concurrentAsync() async {
    printThread("concurrentAsync()")
}

#Playground("6b · Quiz: where does it run?") {
    await plainAsync() // main – the module default is @MainActor
    await nonisolatedAsync() // main – runs on the caller's actor
    await concurrentAsync() // background – explicitly opted in
    let task = Task { printThread("Task") } // main – because Task inherits the caller's actor
    let detached = Task.detached { printThread("Task.detached") } // background – but you rarely need this

    await task.value // wait for both, otherwise the playground ends before they print
    await detached.value
}
