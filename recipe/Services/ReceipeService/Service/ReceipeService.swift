//
//  RecipeService.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/24/24.
//

import Foundation

/// `RecipeService` is an actor responsible for loading recipe data from a remote source.

actor RecipeService {
    private weak var networkService: NetworkServiceable!

    init(networkService: NetworkServiceable) {
        self.networkService = networkService
    }

    func loadRecipes() async -> Result<[Recipe], NetworkServiceError> {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        // let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        // let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        return await loadRecipes(urlString: urlString)
    }

    private func loadRecipes(urlString: String) async -> Result<[Recipe], NetworkServiceError> {
        let request = URLRequest(url: URL(string: urlString)!)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        switch await networkService.codable(Recipes.self, decoder: decoder, from: request) {
        case let .success(data):
            return .success(data.recipes.elements)
        case let .failure(error):
            print("Error: \(error)")
            return .failure(error)
        }
    }
}

// MARK: RecipeService

extension RecipeService: RecipeServiceable {}

#if TEST
extension RecipeService {
    func testLoadRecipes(urlString: String) async -> Result<[Recipe], NetworkServiceError> {
        await loadRecipes(urlString: urlString)
    }
}
#endif
