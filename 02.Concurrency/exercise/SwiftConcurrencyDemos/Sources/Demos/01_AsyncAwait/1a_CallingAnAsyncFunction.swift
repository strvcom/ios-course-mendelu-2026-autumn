import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 1a · Calling an async function

struct User: Sendable {
    let id: Int
    let name: String
}

/// Pretends to load a user from a server: takes 1 s, but doesn't block any thread.
func fetchUser(id: Int) async throws -> User {
    try await Task.sleep(for: .seconds(1)) // ⏸ suspension point
    return User(id: id, name: "Student #\(id)")
}

#Playground("1a · Calling an async function") {
    
    let user = try await fetchUser(id: 1) // ⏸ suspension point
    print("Hello, \(user.name)")

    try await measure("two more users") {
        let second = try await fetchUser(id: 2)
        let third = try await fetchUser(id: 3) // starts only after `second` is done
        print(second.name, third.name)
    }
}
