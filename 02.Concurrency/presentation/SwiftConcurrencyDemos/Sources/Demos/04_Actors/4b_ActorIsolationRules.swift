import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 4b · Actor isolation rules

actor BankAccount {
    let iban: String // immutable → readable from outside without await
    var balance: Decimal = 0 // mutable → isolated: only the actor itself touches it

    init(iban: String) {
        self.iban = iban
    }

    func deposit(_ amount: Decimal) {
        balance += amount // inside the actor: plain synchronous code, no await
    }

    /// Opts out of isolation: callable without await, but may only use immutable state.
    nonisolated var description: String {
        "Account \(iban)"
    }

    // ❌ Uncomment: "Actor-isolated property 'balance' can not be referenced from a nonisolated context"
//    nonisolated func printBalance() { print(balance) }
}

#Playground("4b · Actor isolation rules") {
    let account = BankAccount(iban: "CZ12 3456 7890")

    print(account.iban) // ✅ immutable `let`: no await
    print(account.description) // ✅ nonisolated: no await

//    print("Balance: \(account.balance)")

    await account.deposit(100) // ✅ outside the actor: await
    print("Balance: \(await account.balance)") // ✅ reading mutable state: await

    // ❌ Uncomment one line at a time:
//    account.deposit(100) // "Actor-isolated instance method 'deposit' cannot be called from outside of the actor"
//    await account.balance = 0 // "Actor-isolated property 'balance' can not be mutated from the main actor" – not even with await
}
