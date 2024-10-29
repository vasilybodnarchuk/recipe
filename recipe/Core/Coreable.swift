//
//  Coreable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation
import Combine

///// The `Corable` protocol defines the core interface for managing and initializing
/// essential app components within the `Core` class.

protocol Corable: Actor {
    var events: AnyPublisher<CoreEvent, CoreError> { get }
    func initApp() async
}
