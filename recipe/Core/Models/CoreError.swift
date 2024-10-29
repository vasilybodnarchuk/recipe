//
//  CoreError.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

import Foundation

/// The `CoreError` enum defines error types specific to the `Core` component.
/// This enables consistent error handling within core-related operations.

enum CoreError: Error {
    case other(error: Error)
}
