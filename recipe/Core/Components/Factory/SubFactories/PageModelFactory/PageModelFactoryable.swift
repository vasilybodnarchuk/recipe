//
//  PageModelFactoryable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation

/// The `PageModelFactoryable` protocol defines the interface for a factory
/// responsible for creating `PageModels` (view models) for app pages.

protocol PageModelFactoryable: Actor {
    func createAppLoadingPageModel(pageRouter: any PageRouterable) async -> AppLoadingPageModel
    func createRecipesPageModel(pageRouter: any PageRouterable,
                                recipeService: any RecipeServiceable,
                                imageService: any ImageServiceable) async -> RecipesPageModel
}
