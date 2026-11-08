import GameplayKit

extension Array where Element == GKStateMachine {
    /// Updates each state machine in array order using the same elapsed time.
    func update(deltaTime: TimeInterval) {
        forEach { $0.update(deltaTime: deltaTime) }
    }
}

extension GKStateMachine {
    /// Returns whether the current state is of the requested type.
    func isInState<State: GKState>(_ state: State.Type) -> Bool {
        currentState is State
    }
}
