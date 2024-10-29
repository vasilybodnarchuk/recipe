//
//  RecipeApp.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import SwiftUI
import SwiftData

/// The main entry point for the Recipe app, conforming to the `App` protocol.

@main
struct RecipeApp: App {
    @StateObject private var viewModel = RecipeAppModel()

    var body: some Scene {
        WindowGroup {
            viewModel.rootPage
        }
    }
}
