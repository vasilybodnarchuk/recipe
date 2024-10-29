//
//  Decodable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

import Foundation

enum JSONParseError: Error {
    case fileNotFound
    case dataInitialisation(error: Error)
    case decoding(error: Error)
}

extension Decodable {
    static func from(localJSON filename: String,
                     jsonDecoder: JSONDecoder = JSONDecoder(),
                     bundle: Bundle = .main) -> Result<Self, JSONParseError> {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            return .failure(.fileNotFound)
        }
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch let error {
            return .failure(.dataInitialisation(error: error))
        }

        do {
            return .success(try jsonDecoder.decode(self, from: data))
        } catch let error {
            return .failure(.decoding(error: error))
        }
    }
}
