//
//  ImageService.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import SwiftUI
import CryptoKit

/// `ImageService` is an actor responsible for managing the retrieval, caching,
/// and storage of images within the app.

final actor ImageService {
    private weak var networkService: NetworkServiceable!
    private let cacheService: ImageCacheServiceable
    private let fileStorageService: DataFileStorageServiceable

    init(networkService: NetworkServiceable,
         cacheService: ImageCacheServiceable,
         fileStorageService: DataFileStorageServiceable) {
        self.networkService = networkService
        self.cacheService = cacheService
        self.fileStorageService = fileStorageService
    }
}

// MARK: ImageServiceable

extension ImageService: ImageServiceable {

    // Method to retrieve images
    func uiImage(from url: URL) async -> Result<UIImage, ImageServiceError> {
        let key = uniqueIdentifier(for: url)

        // Check if image already stored
        if let storedImage = await storedImage(forKey: key) {
            log(info: "\(url) loaded from \(storedImage.storageType)")
            return .success(storedImage.image)
        }

        // Load ImageFrom NET
        switch await networkService.data(from: URLRequest(url: url)) {
        case .success(let data):
            guard let fetchedImage = UIImage(data: data) else {
                return .failure(.canNotCreateUIImageFromLoadedData)
            }

            switch await save(image: fetchedImage, forKey: key) {
            case .success: break
            case let .failure(error):
                log(error: error)
            }

            log(info: "\(url) loading from NET")
            return .success(fetchedImage)
        case let .failure(error):
            return .failure(.nested(error: error))
        }
    }
}

// MARK: Other methods

private extension ImageService {
    func log(info text: String) {
        print("-- ImageService: \(text)")
    }

    func log(error: Error) {
        print("-- ImageService Error: \(error)")
    }

    // Transform URL to unique String to save image in the string
    func uniqueIdentifier(for url: URL) -> String {
        let urlString = url.absoluteString
        let data = Data(urlString.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: Read/Write stored image

private extension ImageService {

    enum CacheError: Error {
        case canNotRepresentImageAsData
        case diskWriteError(Error)
    }

    func save(image: UIImage, forKey key: String) async -> Result<URL, CacheError> {
        // Save in memory cache
        await cacheService.save(image: image, forKey: key)

        // Represent Image as Data
        guard let imageData = image.pngData() else {
            return .failure(.canNotRepresentImageAsData)
        }

        // Save to disk cache
        return switch await fileStorageService.save(data: imageData, forKey: key) {
        case let .success(filepath):
            .success(filepath)
        case let .failure(error):
            .failure(.diskWriteError(error))
        }
    }

    enum StoredImage {
        case cached(image: UIImage)
        case loadedFromDisk(image: UIImage)

        var image: UIImage {
            switch self {
            case let .cached(image),
                 let .loadedFromDisk(image):
                image
            }
        }

        var storageType: String {
            switch self {
            case .cached: "CACHE"
            case .loadedFromDisk: "DISK"
            }
        }
    }

    func storedImage(forKey key: String) async -> StoredImage? {

        // Get image from cache
        if let cachedImage = await cacheService.image(forKey: key) {
            return .cached(image: cachedImage)
        }

        // Get Image From storage
        let diskImage: UIImage
        switch await fileStorageService.data(for: key) {
        case let .success(data):
            guard let image = UIImage(data: data) else {
                return nil
            }
            diskImage = image
        case .failure:
            return nil
        }

        // Load image into memory cache for faster future access
        await cacheService.save(image: diskImage, forKey: key)
        return .loadedFromDisk(image: diskImage)
    }
}
