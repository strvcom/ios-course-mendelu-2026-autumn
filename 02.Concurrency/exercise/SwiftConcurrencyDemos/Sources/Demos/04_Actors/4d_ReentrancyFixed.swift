import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 4d · Reentrancy fixed
// `BankAccount` is the actor from 4b_ActorIsolationRules.swift, `authorize(_:)` lives in Authorize.swift.

extension BankAccount {
    /// Fix: change the state BEFORE suspending, and undo it if the bank says no.
    func withdrawSafely(_ amount: Decimal) async -> Bool {
        guard balance >= amount else {
            print("⛔️ \(amount) declined – balance is only \(balance)")
            return false
        }
        balance -= amount // reserve the money before the first await
        print("🔒 reserved \(amount) – asking the bank…")
        guard await authorize(amount) else {
            balance += amount // the bank said no → give the money back
            return false
        }
        print("💸 paid out \(amount) – balance \(balance)")
        return true
    }
}

#Playground("4d · Reentrancy fixed") {
    let account = BankAccount(iban: "CZ12 3456 7890")
    await account.deposit(100)

    async let first = account.withdrawSafely(80) // the same two withdrawals
    async let second = account.withdrawSafely(80)
    let approved = await [first, second]

    print("Approved: \(approved), balance: \(await account.balance)")
}
