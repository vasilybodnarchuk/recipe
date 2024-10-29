//
//  Recipe.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/24/24.
//

import Foundation

struct Recipe: Codable {
    let uuid: String
    let name: String
    let cuisine: String
    let photoUrlLarge: URL?
    let photoUrlSmall: URL?
    let sourceUrl: URL?
    let youtubeUrl: URL?
}

extension Recipe: RecipeViewRepresentable {
    var sectionTitle: String { cuisine }
    var imageStatus: RecipesPageState.List.Section.Item.Recipe.ImageStatus {
        guard let imageURL = photoUrlSmall ?? photoUrlLarge else {
            return .doesNotExist
        }
        return .needToLoad(url: imageURL)
    }
}
