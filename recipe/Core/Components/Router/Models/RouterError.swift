//
//  RouterError.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation

/// The `RouterError` enum defines error types specific to the routing system,
/// providing a way to encapsulate errors that occur during navigation or
/// presentation operations within the app.

enum RouterError: Error {
    case other(error: Error)
}
