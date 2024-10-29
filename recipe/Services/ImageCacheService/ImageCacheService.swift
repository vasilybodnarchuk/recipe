//
//  ImageCacheService.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

import Foundation
import UIKit

/// `ImageCacheService` is an actor responsible for managing an in-memory cache
/// of images using `NSCache`. It allows for asynchronous saving and retrieval
/// of images, enabling efficient image caching with a unique key-based system.

actor ImageCacheService {
    fileprivate lazy var cache = NSCache<NSString, UIImage>()
}

extension ImageCacheService: ImageCacheServiceable {

    func save(image: UIImage, forKey key: String) async {
        cache.setObject(image, forKey: key as NSString)
    }

    func image(forKey key: String) async -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}
