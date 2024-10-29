//
//  RecipesPageState+ListItem.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/25/24.
//

import Foundation

extension RecipesPageState {
    class List { }
}

// MARK: List Section

extension RecipesPageState.List {
    enum Section {
        case regular(viewId: String, title: String, items: [Item])
    }
}

extension RecipesPageState.List.Section: Identifiable {
    var id: String {
        return switch self {
        case let .regular(viewId, _, _): viewId
        }
    }

    static func regular(title: String, items: [Item]) -> Self {
        .regular(viewId: UUID().uuidString, title: title, items: items)
    }
}

// MARK: List Item

extension RecipesPageState.List.Section {
    enum Item {
        case recipe(viewId: String, recipe: Recipe)
    }
}

extension RecipesPageState.List.Section.Item: Identifiable {

    var id: String {
        return switch self {
        case let .recipe(viewId, _): viewId
        }
    }

    static func recipe(recipe: Recipe) -> Self {
        .recipe(viewId: UUID().uuidString, recipe: recipe)
    }
}
