//
//  ImageCacheServiceable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

import Foundation
import UIKit

/// The `ImageCacheServiceable` protocol defines an interface for an image caching service.

protocol ImageCacheServiceable: Actor {
    func save(image: UIImage, forKey key: String) async
    func image(forKey key: String) async -> UIImage?
}
