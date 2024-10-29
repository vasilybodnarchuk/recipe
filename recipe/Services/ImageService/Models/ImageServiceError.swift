//
//  ImageServiceError.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/26/24.
//

import Foundation

/// The `ImageServiceError` enum defines error types specific to image-related
/// operations within the app. These errors can occur during image loading,
/// processing, or conversion, and provide structured cases to handle
/// common failure scenarios.

enum ImageServiceError: Error {
    case canNotCreateUIImageFromLoadedData
    case nested(error: Error)
}
