//
//  DataFileStorageService.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

import Foundation

/// `DataFileStorageService` is an actor responsible for managing the storage and retrieval
/// of data files on dis

actor DataFileStorageService {
    fileprivate let diskCacheDirectory: URL

    init(directory: FileManager.SearchPathDirectory,
         in domainMask: FileManager.SearchPathDomainMask,
         directoryName: String) {

        // Set up the disk cache directory
        let paths = FileManager.default.urls(for: directory, in: domainMask)
        diskCacheDirectory = paths[0].appendingPathComponent(directoryName)

        // Create the directory if it doesn't exist
        do {
            try FileManager.default.createDirectory(at: diskCacheDirectory,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch let error {
            print("-- DataFileStorageService: Error: \(error)")
        }
    }
}

// MARK: DataFileStorageServiceable

extension DataFileStorageService: DataFileStorageServiceable {

    func save(data: Data, forKey key: String) async -> Result<URL, DataFileStorageServiceError> {
        let url = diskCacheDirectory.appendingPathComponent(key)
        do {
            try data.write(to: url)
            return .success(url)
        } catch let error {
            return .failure(.diskWriteError(error))
        }
    }

    func data(for key: String) async -> Result<Data, DataFileStorageServiceError> {
        do {
            let url = diskCacheDirectory.appendingPathComponent(key)
            return .success(try Data(contentsOf: url))
        } catch let error {
            return .failure(.diskWriteError(error))
        }
    }
}
