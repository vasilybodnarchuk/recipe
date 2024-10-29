//
//  NetworkService.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation

/// `NetworkService` is an actor responsible for handling network requests
/// and providing various response formats, such as raw data, text, JSON dictionaries,
/// and Codable objects. It supports asynchronous network requests with robust error handling,
/// leveraging `URLSession` and customizable decoding options.

final actor NetworkService {
    init() {
        URLSession.shared.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    }
}

// MARK: NetworkManagerable

extension NetworkService: NetworkServiceable {
    func data(from request: URLRequest,
              session: URLSession) async -> Result<Data, NetworkServiceError> {
        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unexpectedBehavior)
            }
            print("------------------------------")
            print("NETWORK Request: \(request)")
            print("NETWORK response: \(response)")

            if !(200...299).contains(httpResponse.statusCode) {
                return .failure(.httpError(statusCode: httpResponse.statusCode))
            }

            return .success(data)

        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                return .failure(.networkUnreachable)
            case .timedOut:
                return .failure(.timeout)
            case .networkConnectionLost:
                return .failure(.connectionLost)
            default:
                return .failure(.dataTask(error: error))
            }
        } catch let error {
            return .failure(.dataTask(error: error))
        }
    }

    func text(from request: URLRequest,
              session: URLSession) async -> Result<String, NetworkServiceError> {
        switch await data(from: request, session: session) {
        case let .success(data):
            let encoding = String.Encoding.utf8
            guard let text = String(data: data, encoding: encoding) else {
                return .failure(.canNotEncode(data: data, encoding: encoding))
            }
            return .success(text)
        case let .failure(error):
            return .failure(.dataTask(error: error))
        }
    }
}

// MARK: Receive Codable

extension NetworkService {
    private func codable<Value>(_ type: Value.Type,
                                from data: Data,
                                decoder: JSONDecoder) -> Result<Value, NetworkServiceError>
    where Value: Decodable, Value: Encodable {
        do {
            let codableValue = try decoder.decode(Value.self, from: data)
            return .success(codableValue)
        } catch let error {
            return .failure(.jsonDecoding(error: error))
        }
    }

    func codable<Value>(_ type: Value.Type,
                        from request: URLRequest,
                        decoder: JSONDecoder,
                        session: URLSession) async -> Result<Value, NetworkServiceError>
    where Value: Decodable, Value: Encodable {
        switch await data(from: request, session: session) {
        case let .success(data):
            return codable(type, from: data, decoder: decoder)
        case let .failure(error):
            return .failure(.dataTask(error: error))
        }
    }
}

// MARK: Receive Dictionary

extension NetworkService {

    private func dictionary(from data: Data,
                            jsonReadingOptions: JSONReadingOptions) -> Result<[String: Any], NetworkServiceError> {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: jsonReadingOptions)
            guard let dictionary = json as? [String: Any] else {
                return .failure(.castingError(value: json, isNot: [String: Any].self))
            }
            return .success(dictionary)

        } catch let error {
            return .failure(.jsonSerialization(error: error))
        }
    }

    func dictionary(from request: URLRequest,
                    session: URLSession,
                    jsonReadingOptions: JSONReadingOptions) async -> Result<[String: Any], NetworkServiceError> {
        switch await data(from: request, session: session) {
        case let .success(data):
            return dictionary(from: data, jsonReadingOptions: jsonReadingOptions)
        case let .failure(error):
            return .failure(.dataTask(error: error))
        }
    }
}
