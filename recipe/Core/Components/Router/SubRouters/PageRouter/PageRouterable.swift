//
//  PageRouterable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation
import SwiftUI
import Combine

/// The `PageRouterable` protocol defines an interface for routing to specific pages
/// within the app.

protocol PageRouterable: AnyObject, ObservableObject {
    func showRecipesPage()
}
