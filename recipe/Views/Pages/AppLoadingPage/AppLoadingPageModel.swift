//
//  AppLoadingPageModel.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation
import Combine

/// `AppLoadingPageModel` is a view model for the `AppLoadingPage` view, responsible
/// for managing the app’s initial loading logic.

final class AppLoadingPageModel {
    private(set) var pageRouter: any PageRouterable

    init(pageRouter: any PageRouterable) {
        self.pageRouter = pageRouter
        Task {
            pageRouter.showRecipesPage()
        }
    }
}

// MARK: ObservableObject

extension AppLoadingPageModel: ObservableObject {}
