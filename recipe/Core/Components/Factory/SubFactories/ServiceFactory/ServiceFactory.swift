//
//  ServiceFactory.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation

/// The `ServiceFactory` actor is responsible for creating and managing all
/// services used throughout the app.

final actor ServiceFactory {
    private var _networkService: NetworkServiceable!
    private var _imageService: ImageServiceable!
}

// MARK: ServiceFactoryable

extension ServiceFactory: ServiceFactoryable {
    func getNetworkService() async -> NetworkServiceable {
        if let service = _networkService { return service }
        _networkService = NetworkService()
        return _networkService!
    }

    func getImageService() async -> ImageServiceable {
        if let service = _imageService { return service }
        _imageService = await ImageService(networkService: getNetworkService(),
                                           cacheService: createImageCacheService(),
                                           fileStorageService: DataFileStorageService(directory: .cachesDirectory,
                                                                                      in: .userDomainMask,
                                                                                      directoryName: "ImageCache"))
        return _imageService!
    }

    func getRecipeService() async -> RecipeServiceable {
        await RecipeService(networkService: getNetworkService())
    }
}

// MARK: Creators

private extension ServiceFactory {
    func createImageCacheService() async -> ImageCacheServiceable {
        ImageCacheService()
    }
}
