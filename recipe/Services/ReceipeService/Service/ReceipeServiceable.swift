//
//  RecipeServiceable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/24/24.
//

import Foundation

/// The `RecipeServiceable` protocol defines an interface for a service that loads recipe data

protocol RecipeServiceable: Actor {
    func loadRecipes() async -> Result<[Recipe], NetworkServiceError>
}
