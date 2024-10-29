//
//  RouterEvent.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation
import SwiftUI

/// The `RouterEvent` enum defines various events that can be triggered within
/// the routing system, providing a structured way to handle navigation-related
/// actions, such as displaying alerts or rendering specific pages.

enum RouterEvent {
    case showAlert(error: Error)
    case render(page: AnyView)
}
