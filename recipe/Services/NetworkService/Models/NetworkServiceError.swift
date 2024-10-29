//
//  NetworkServiceError.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation

enum NetworkServiceError: LocalizedError {
    case dataTask(error: Error)
    case emptyData
    case jsonSerialization(error: Error)
    case castingError(value: Any, isNot: Any)
    case networkMangerIsNotExists
    case jsonDecoding(error: Error)
    case canNotEncode(data: Data, encoding: String.Encoding)
    case httpError(statusCode: Int)
    case networkUnreachable
    case timeout
    case connectionLost
    case unexpectedBehavior
}

// MARK: Error

extension NetworkServiceError {
    public var errorDescription: String? {
        switch self {
        case .dataTask(let error):
            "A data task error occurred: \(error.localizedDescription)"
        case .emptyData:
            "The response data was empty."
        case .jsonSerialization(let error):
            "Failed to serialize JSON: \(error.localizedDescription)"
        case .castingError(let value, let isNot):
            "Failed to cast \(value) to \(isNot)."
        case .networkMangerIsNotExists:
            "The network manager does not exist."
        case .jsonDecoding(let error):
            "Failed to decode JSON: \(error.localizedDescription)"
        case .canNotEncode(let data, let encoding):
            "Failed to encode data: \(data.count) bytes using \(encoding)."
        case .httpError(let statusCode):
            "Received HTTP error with status code: \(statusCode)"
        case .networkUnreachable:
            "The network is unreachable. Please check your connection."
        case .timeout:
            "The request timed out."
        case .connectionLost:
            "The network connection was lost."
        case .unexpectedBehavior:
            "An unexpected behavior occurred."
        }
    }
}
