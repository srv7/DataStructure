//
//  Queue.swift
//  DataStructure
//
//  Created by liubo on 2018/5/2.
//  Copyright © 2018年 cloudist. All rights reserved.
//

import Foundation

public struct Queue<T> {
    private var elements: [T] = []
    
    public init() {}
    
    public init<S: Sequence>(_ s: S) where S.Iterator.Element == T {
        self.elements.append(contentsOf: s)
    }
    
    public mutating func dequeue() -> T? {
        return elements.removeFirst()
    }
    
    public mutating func enqueue(_ element: T) {
        return elements.append(element)
    }
    
    public func peek() -> T? {
        return elements.first
    }
    
    public mutating func clear() {
        elements.removeAll()
    }
    
    public var count: Int {
        return elements.count
    }
    
    public var isEmpty: Bool {
        return elements.isEmpty
    }
}

extension Queue: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return elements.description
    }
    
    public var debugDescription: String {
        return elements.debugDescription
    }
}

extension Queue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}

extension Queue: Sequence {
    
    public func makeIterator() -> AnyIterator<T> {
        return AnyIterator(IndexingIterator(_elements: self.elements.lazy))
    }
}

extension Queue: Collection {
    public func check(index: Int) {
        if index < 0 || index > count {
            fatalError("Index out of range")
        }
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count - 1
    }

    public func index(after i: Int) -> Int {
        return elements.index(after: i)
    }

    public subscript(index: Int) -> T {
        check(index: index)
        return elements[index]
    }
}








