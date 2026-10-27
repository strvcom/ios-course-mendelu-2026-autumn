# Swift Concurrency – lecture demos

Live demos for the MENDELU Swift Concurrency lecture. Every demo is its own Swift file with one Xcode **`#Playground`** block, and the files are grouped in one folder per topic. You run a demo in the canvas next to the code, like a SwiftUI preview.

## Requirements

- Xcode 26 or newer (Swift 6.2+)
- macOS 15+ or iOS 26+ (simulator)

## How to run

1. Open `Package.swift` in Xcode. Run destination: **My Mac** (or an iOS 26 simulator).
2. Open a demo file, e.g. `Sources/Demos/01_AsyncAwait/1a_CallingAnAsyncFunction.swift`.
3. Show the canvas: **Editor ▸ Canvas** (⌥⌘↩). If the playground is paused, press **Resume**.

Lines marked `❌ Uncomment` show compile-time errors. Uncomment one, read the error, then comment it out again.

## What's inside

| Folder | Demos |
|---|---|
| `Sources/Demos/01_AsyncAwait/` | 1a calling an async function · 1b async ≠ background thread · 1c AsyncSequence |
| `Sources/Demos/02_StructuredConcurrency/` | 2a sequential · 2b `async let` · 2c TaskGroup · 2d cancellation · 2e `Task {}` is not a child |
| `Sources/Demos/03_DataRace/` | 3 a data race at runtime (and the compile error without `@unchecked Sendable`) |
| `Sources/Demos/04_Actors/` | 4a an actor fixes the data race · 4b actor isolation rules · 4c actor reentrancy (bank overdraft) · 4d reentrancy fixed · 4e `@MainActor` view model |
| `Sources/Demos/05_Sendable/` | 5a crossing isolation boundaries · 5b a Sendable class with a `Mutex` |
| `Sources/ApproachableDemos/06_ApproachableConcurrency/` | 6a who is blocking the main thread? · 6b quiz: where does it run? |
| `DownloadImage.swift`, `Authorize.swift` | fake services next to the demos that use them (Demos 2a–2c and 4c–4d) |
| `Sources/Helpers/` | `printThread()`, `measure()`, `startHeartbeat()` |

## Build settings

All targets use the **Swift 6 language mode**, so data races are compile errors.

- `Demos` turns on `NonisolatedNonsendingByDefault`: a plain `async` function runs on the caller's actor.
- `ApproachableDemos` also uses `.defaultIsolation(MainActor.self)`. These are the same settings a new Xcode 26+ app project gets.
