//
//  RecipesPageState+List+Recipe.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/25/24.
//

import Foundation
import SwiftUI

extension RecipesPageState.List.Section.Item {
    class Recipe {
        let name: String
        let cuisine: String
        var imageStatus: ImageStatus

        init(name: String, cuisine: String, imageStatus: ImageStatus) {
            self.name = name
            self.cuisine = cuisine
            self.imageStatus = imageStatus
        }
    }
}

// MARK: RecipeViewRepresentable

extension RecipesPageState.List.Section.Item.Recipe: RecipeViewRepresentable {
    var sectionTitle: String {
        cuisine
    }
}

// MARK: Receipe Image

extension RecipesPageState.List.Section.Item.Recipe {
    enum ImageStatus {
        case doesNotExist
        case needToLoad(url: URL)
        case uiImage(UIImage)
    }
}
