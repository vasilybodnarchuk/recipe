//
//  RecipesPageListGrouping.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/25/24.
//

enum RecipesPageListGrouping {
    case none
    case byCuisineAscending

    var next: Self {
        switch self {
        case .none: .byCuisineAscending
        case .byCuisineAscending: .none
        }
    }

    var iconSystemImageName: String {
        switch self {
        case .none: "list.bullet"
        case .byCuisineAscending: "rectangle.3.group"
        }
    }
}
