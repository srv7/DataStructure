////
////  Stack.swift
////  DataStructure
////
////  Created by liubo on 2018/5/2.
////  Copyright © 2018年 cloudist. All rights reserved.
////
//
//import Foundation
//
//public struct Stack<T> {
//    private var elements: [T] = []
//    public init() {}
//    
//    public init<S: Sequence>(_ s: S) where S.Iterator.Element == T {
//        self.elements = Array(s.reversed())
//    }
//    
//    public mutating func pop() -> T? {
//        return elements.popLast()
//    }
//    
//    public mutating func push(_ element: T) {
//        elements.append(element)
//    }
//    
//    public func peek() -> T? {
//        return elements.last
//    }
//    
//    public var isEmpty: Bool {
//        return elements.isEmpty
//    }
//    
//    public var count: Int {
//        return elements.count
//    }
//}
//
//extension Stack: CustomStringConvertible, CustomDebugStringConvertible {
//    public var description: String {
//        return elements.description
//    }
//    
//    public var debugDescription: String {
//        return elements.debugDescription
//    }
//    
//}
//
//extension Stack: ExpressibleByArrayLiteral {
//
//    public init(arrayLiteral elements: T...) {
//        self.init(elements)
//    }
//}
//
//extension Stack: Sequence {
//    public func makeIterator() -> AnyIterator<T> {
//        return AnyIterator(IndexingIterator(_elements: self.elements.lazy.reversed()))
//    }
//}
//
//
