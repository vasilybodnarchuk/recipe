//
//  Untitled.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/25/24.
//

import Foundation
import Combine

/// `IsolatedValue` is a thread-safe container for managing a value that needs
/// isolation from concurrent access.

final actor IsolatedValue<Value>: Isolatable where Value: Sendable {
    private(set) var value: Value

    init(value: Value) {
        self.value = value
    }

    func set(value: Value) {
        self.value = value
    }

    func update(closure: (_ currentValue: inout Value) -> Void) {
        closure(&value)
    }
}
