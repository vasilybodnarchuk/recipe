//
//  DataFileStorageServiceError.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

enum DataFileStorageServiceError: Error {
    case diskWriteError(Error)
}
