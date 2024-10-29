//
//  Isolatable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/25/24.
//

import Foundation

/// The `Isolatable` protocol defines an interface for a thread-safe, isolated value container.
/// Types conforming to `Isolatable` can safely manage access to a value that may need
/// to be accessed or modified across different contexts, ensuring that the value remains
/// thread-safe and isolated as needed.
/// - Note: `Value` must conform to `Sendable` for safe cross-actor operations.

protocol Isolatable: Sendable {
    associatedtype Value: Sendable
    var value: Value { get async }
    init(value: Value)
    func set(value: Value) async
}
