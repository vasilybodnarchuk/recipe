//
//  PageModelFactory.swift

//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import SwiftUI

/// The `PageModelFactory` actor is responsible for creating any `PageModel` (view model)
/// for app pages, ensuring that each page has the necessary models and dependencies to manage
/// its state and data effectively.

final actor PageModelFactory {}

// MARK: PageFactoryable

extension PageModelFactory: PageModelFactoryable {
    func createAppLoadingPageModel(pageRouter: any PageRouterable) async -> AppLoadingPageModel {
        AppLoadingPageModel(pageRouter: pageRouter)
    }

    func createRecipesPageModel(pageRouter: any PageRouterable,
                                recipeService: any RecipeServiceable,
                                imageService: any ImageServiceable) async -> RecipesPageModel {
        RecipesPageModel(pageRouter: pageRouter,
                         recipeService: recipeService,
                         imageService: imageService)
    }
}
