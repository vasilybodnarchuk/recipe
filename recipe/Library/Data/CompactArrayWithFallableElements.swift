//
//  CompactArrayWithFallableElements.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

import Foundation

/// `CompactArrayWithFallableElements` is a custom array wrapper that supports decoding an array
/// with fallible elements. When decoding, it attempts to decode each element individually;
/// if decoding fails for a particular element, that element is skipped without causing an error,
/// allowing the remaining elements to be decoded successfully.

class CompactArrayWithFallableElements<Element>: Codable where Element: Codable {
    private(set) var elements = [Element]()
    required init(from decoder: Decoder) throws {
        guard var unkeyedContainer = try? decoder.unkeyedContainer() else { return }
        while !unkeyedContainer.isAtEnd {
            if let value = try? unkeyedContainer.decode(Element.self) {
                elements.append(value)
            } else {
                unkeyedContainer.skip()
            }
        }
    }
}

// https://forums.swift.org/t/pitch-unkeyeddecodingcontainer-movenext-to-skip-items-in-deserialization/22151/17

struct Empty: Codable { }

extension UnkeyedDecodingContainer {
    mutating func skip() { _ = try? decode(Empty.self) }
}
