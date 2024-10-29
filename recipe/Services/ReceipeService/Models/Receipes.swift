//
//  Recipes.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/24/24.
//

import Foundation

struct Recipes: Codable {
    let recipes: CompactArrayWithFallableElements<Recipe>
}
