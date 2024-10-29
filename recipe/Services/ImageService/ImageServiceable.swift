//
//  ImageServiceable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import UIKit

/// The `ImageServiceable` protocol defines an interface for a service that loads images
/// from a specified URL and converts them into `UIImage` instances.

protocol ImageServiceable: Actor {
    func uiImage(from url: URL) async -> Result<UIImage, ImageServiceError>
}
