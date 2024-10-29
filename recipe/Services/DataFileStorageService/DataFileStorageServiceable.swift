//
//  DataFileStorageServiceable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

import Foundation

/// The `DataFileStorageServiceable` protocol defines an interface for
/// a service that manages the storage and retrieval of data files.
/// It provides asynchronous methods for saving and loading data files

protocol DataFileStorageServiceable: Actor {
    func save(data: Data, forKey key: String) async -> Result<URL, DataFileStorageServiceError>
    func data(for key: String) async -> Result<Data, DataFileStorageServiceError>
}
