//
//  PageFactoryable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/24/24.
//

import SwiftUI

/// The `PageFactoryable` protocol defines the interface for a factory responsible
/// for creating pages within the app.

protocol PageFactoryable: Actor {
    nonisolated func createAppLoadingPage(pageRouter: any PageRouterable) -> AnyView
    nonisolated func createRecipesPage(pageRouter: any PageRouterable) -> AnyView
}
