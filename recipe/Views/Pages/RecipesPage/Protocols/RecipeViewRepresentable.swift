//
//  RecipeViewRepresentable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/25/24.
//

import Foundation

protocol RecipeViewRepresentable {
    var sectionTitle: String { get }
    var cuisine: String { get }
    var name: String { get }
    var imageStatus: RecipesPageState.List.Section.Item.Recipe.ImageStatus { get }
}
