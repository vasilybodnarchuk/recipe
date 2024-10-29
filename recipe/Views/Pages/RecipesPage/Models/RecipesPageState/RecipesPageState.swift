//
//  RecipesPageState.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/25/24.
//

import Foundation

enum RecipesPageState {
    case loading(viewId: String)
    case noData
    case error(viewId: String, text: String)
    case list(sections: [List.Section])
}

// MARK: Initializers

extension RecipesPageState {
    static var loading: Self {
        .loading(viewId: UUID().uuidString)
    }

    static func error(text: String) -> Self {
        .error(viewId: UUID().uuidString, text: text)
    }
}
