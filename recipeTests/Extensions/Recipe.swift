//
//  Recipe.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

import Foundation
@testable import recipe

extension Recipe: @retroactive Equatable {
    public static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.cuisine == rhs.cuisine &&
            lhs.name == rhs.name &&
            lhs.uuid == rhs.uuid &&
            lhs.photoUrlLarge == rhs.photoUrlLarge &&
            lhs.photoUrlSmall == rhs.photoUrlSmall &&
            lhs.sourceUrl == rhs.sourceUrl &&
            lhs.youtubeUrl == rhs.youtubeUrl
    }
}
