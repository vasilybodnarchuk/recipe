//
//  MainActorIsolatedValue.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/25/24.
//

import Foundation

/// `MainActorIsolatedValue` is a thread-safe wrapper that isolates a value
/// to the main actor, ensuring synchronized access and modifications on the main thread.
/// It provides a safe way to manage state that must remain thread-safe and confined to
/// the main thread, such as UI-related data.
/// - Note: `Value` must conform to `Sendable` for safe cross-actor operations.

final actor MainActorIsolatedValue<Value>: Isolatable where Value: Sendable {
    @MainActor private(set) var value: Value

    init(value: Value) {
        self.value = value
    }

    @MainActor
    func set(value: Value) {
        self.value = value
    }
}

// MARK: Update

extension MainActorIsolatedValue {

    @MainActor
    @discardableResult
    func update(closure: @Sendable (Value) -> UpdateRequest) -> UpdateResult {
        switch closure(value) {
        case .doNotChange:
            return .same(value: value)
        case let .set(newValue):
            value = newValue
            return .changed(newValue: newValue)
        }
    }

    enum UpdateRequest {
        case doNotChange
        case set(newValue: Value)
    }

    enum UpdateResult {
        case changed(newValue: Value)
        case same(value: Value)
    }
}
