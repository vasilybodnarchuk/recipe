//
//  ServiceFactoryable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation

/// The `ServiceFactoryable` protocol defines an interface for a factory
/// responsible for providing access to services throughout the app.

protocol ServiceFactoryable: Actor {
    func getNetworkService() async -> NetworkServiceable
    func getImageService() async -> ImageServiceable
    func getRecipeService() async -> RecipeServiceable
}
