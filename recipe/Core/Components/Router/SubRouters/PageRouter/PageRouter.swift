//
//  PageRouter.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation
import SwiftUI
import Combine

/// The `PageRouter` class serves as an external wrapper for the `SystemRouter` component.
/// While `SystemRouter` is isolated within `Core`, `PageRouter` provides a safe interface
/// to access navigation and presentation functionalities outside `Core`, maintaining
/// controlled access to essential app navigation features.

final class PageRouter {
    private weak var systemRouter: SystemRouterable!
    init(systemRouter: SystemRouterable) {
        self.systemRouter = systemRouter
    }
}

// MARK: PageRouterable

extension PageRouter: PageRouterable {
    func showRecipesPage() {
        Task {
            await systemRouter.showRecipesPage()
        }
    }
}
