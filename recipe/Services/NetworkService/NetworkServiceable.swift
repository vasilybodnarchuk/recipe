//
//  NetworkServiceable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation

/// The `NetworkServiceable` protocol defines an interface for a network service,
/// providing asynchronous methods for retrieving various types of data from network requests.

protocol NetworkServiceable: Actor {
    typealias JSONReadingOptions = JSONSerialization.ReadingOptions
    func data(from request: URLRequest,
              session: URLSession) async -> Result<Data, NetworkServiceError>
    func text(from request: URLRequest,
              session: URLSession) async -> Result<String, NetworkServiceError>
    func dictionary(from request: URLRequest,
                    session: URLSession,
                    jsonReadingOptions: JSONReadingOptions) async -> Result<[String: Any], NetworkServiceError>
    func codable<Value>(_ type: Value.Type,
                        from request: URLRequest,
                        decoder: JSONDecoder,
                        session: URLSession) async -> Result<Value, NetworkServiceError> where Value: Codable
}

extension NetworkServiceable {
    func data(from request: URLRequest) async -> Result<Data, NetworkServiceError> {
        await data(from: request, session: .shared)
    }

    func text(from request: URLRequest) async -> Result<String, NetworkServiceError> {
        await text(from: request, session: .shared)
    }

    func dictionary(from request: URLRequest,
                    jsonReadingOptions: JSONReadingOptions = .mutableContainers)
    async -> Result<[String: Any], NetworkServiceError> {
        await dictionary(from: request, session: .shared, jsonReadingOptions: jsonReadingOptions)
    }

    func codable<Value>(_ type: Value.Type,
                        decoder: JSONDecoder = .init(),
                        from request: URLRequest) async -> Result<Value, NetworkServiceError> where Value: Codable {
        await codable(type, from: request, decoder: decoder, session: .shared)
    }
}
