//
//  SystemRouterable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation
import SwiftUI
import Combine

/// The `SystemRouterable` protocol defines the interface for a system router,
/// responsible for managing navigation and presentation logic across the app.

protocol SystemRouterable: AnyObject {

    var events: AnyPublisher<RouterEvent, RouterError> { get }

    func showGlobalAlert(error: Error)
    func showAppLoadingPage() async
    func showRecipesPage() async
}
