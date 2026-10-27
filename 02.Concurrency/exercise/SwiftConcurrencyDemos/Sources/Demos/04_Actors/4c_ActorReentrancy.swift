import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 4c · Actor reentrancy
// `BankAccount` is the actor from 4b_ActorIsolationRules.swift, `authorize(_:)` lives in Authorize.swift.

extension BankAccount {
    /// Looks correct… but isn't.
    func withdraw(_ amount: Decimal) async -> Bool {
        guard balance >= amount else {
            print("⛔️ \(amount) declined – balance is only \(balance)")
            return false
        }
        print("✅ \(amount) available – asking the bank…")
        guard await authorize(amount) else { return false } // ⏸ other callers can enter the actor HERE
        balance -= amount // 💥 the check above may no longer be true
        print("💸 paid out \(amount) – balance \(balance)")
        return true
    }

    /// Pretends to ask the bank to approve a payment: takes 1 second, but doesn't block any thread.
    func authorize(_ amount: Decimal) async -> Bool {
        try? await Task.sleep(for: .seconds(1))
        return true
    }
}

#Playground("4c · Actor reentrancy") {
    let account = BankAccount(iban: "CZ12 3456 7890")
    await account.deposit(100)

    async let first = account.withdraw(80) // two withdrawals at the same time
    async let second = account.withdraw(80)
    let approved = await [first, second]

    print("Approved: \(approved), balance: \(await account.balance)") // 💥 we paid out more than we had
}
