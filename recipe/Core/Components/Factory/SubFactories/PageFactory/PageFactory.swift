//
//  PageFactory.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/24/24.
//

import SwiftUI

/// The `PageFactory` actor is responsible for creating views for app pages..

final actor PageFactory {
    private let pageModelFactory: PageModelFactoryable = PageModelFactory()
    private weak var serviceFactory: ServiceFactoryable!

    init(serviceFactory: ServiceFactoryable) {
        self.serviceFactory = serviceFactory
    }
}

// MARK: PageFactoryable

extension PageFactory: PageFactoryable {
    nonisolated func createAppLoadingPage(pageRouter: any PageRouterable) -> AnyView {
        AnyView(ViewWithAsyncViewModelInit {
            await self.pageModelFactory
                .createAppLoadingPageModel(pageRouter: pageRouter)
        } viewOnLoading: {
            ProgressView()
        } viewWhenLoaded: { pageModel in
            AppLoadingPage(pageModel: pageModel)
        })
    }

    nonisolated func createRecipesPage(pageRouter: any PageRouterable) -> AnyView {
        AnyView(ViewWithAsyncViewModelInit {
            await self.pageModelFactory
                .createRecipesPageModel(pageRouter: pageRouter,
                                        recipeService: self.serviceFactory.getRecipeService(),
                                        imageService: self.serviceFactory.getImageService())
        } viewOnLoading: {
            ProgressView()
        } viewWhenLoaded: { pageModel in
            RecipesPage(pageModel: pageModel)
        })
    }
}
