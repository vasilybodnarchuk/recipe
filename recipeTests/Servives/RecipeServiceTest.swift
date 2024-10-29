//
//  RecipeServiceTest.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

import XCTest
@testable import recipe

final class RecipeServiceTests: XCTestCase {
    private var recipeService: RecipeService!
    private var networkService: NetworkServiceable!
    private var jsonDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()

    override func setUp() {
        super.setUp()
        networkService = NetworkService()
        recipeService = RecipeService(networkService: networkService)
    }

    override func tearDown() {
        recipeService = nil
        networkService = nil
        super.tearDown()
    }

    private func _testRecipesList(urlString: String, mockDataJSONFileName: String) async {
        switch await recipeService.testLoadRecipes(urlString: urlString) {
        case let .success(recipes):
            switch Recipes.from(localJSON: mockDataJSONFileName,
                                jsonDecoder: jsonDecoder,
                                bundle: .init(for: Self.self)) {
            case let .success(expectedRecipes):
                for (offset, recipe) in recipes.enumerated() {
                    XCTAssertEqual(expectedRecipes.recipes.elements[offset], recipe, "Recipes should be equal")
                }
            case let .failure(error):
                XCTFail("Can not parse JSON file to the object. Error: \(error)")
            }
        case .failure:
            XCTFail("API should work")
        }
    }

    func testRecipesList() async {
        await _testRecipesList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json",
                               mockDataJSONFileName: "ReceipesListValid")
    }

    func testRecipesListMalformed() async {
        await _testRecipesList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json",
                               mockDataJSONFileName: "ReceipesListMalformed")
    }

    func testRecipesListEmpty() async {
        await _testRecipesList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json",
                               mockDataJSONFileName: "ReceipesListEmpty")
    }
}
