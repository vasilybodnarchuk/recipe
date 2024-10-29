//
//  Node.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/25/24.
//

import Foundation

class Node<Value> {

    private(set) var value: Value
    private(set) var next: Node?
    private(set) var last: Node?
    private(set) var count: Int

    init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
        self.last = next
        count = 1
    }

    func append(value: Value) {
        let newNode = Node(value: value)
        if next == nil {
            next = newNode
        } else {
            last?.next = newNode
        }
        last = newNode
        count += 1
    }

    func toArray() -> [Value] {
        var result = [Value]()
        result.reserveCapacity(count)

        var node: Node? = self
        while node != nil {
            guard let currentNode = node else { break }
            result.append(currentNode.value)
            node = node?.next
        }

        return result
    }
}
