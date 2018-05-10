//
//  CircularBuffer.swift
//  DataStructure
//
//  Created by liubo on 2018/5/2.
//  Copyright © 2018年 cloudist. All rights reserved.
//

import Foundation

fileprivate struct Constant {
    fileprivate static let defaultQueueCapacity: Int = 16
}

public struct CircularBuffer<T> {
    
    public enum OverwriteOperation {
        case ignore
        case overwrite
    }
    
    private var elements: [T?]
    private var head: Int = 0
    private var tail: Int = 0
    private(set) var capacity: Int
    private var internalCount: Int = 0
    
    private(set) var overwriteOperation: OverwriteOperation = .overwrite
    
    public var count: Int {
        return internalCount
    }
    
    public var isEmpty: Bool {
        return internalCount == 0
    }
    
    public var isFull: Bool {
        return internalCount == capacity
    }
    
    init() {
        elements = [T?]()
        capacity = Constant.defaultQueueCapacity
    }
    
    init(_ size: Int, overwriteOperation: OverwriteOperation = .overwrite) {
        elements = [T?]()
        capacity = size
        self.overwriteOperation = overwriteOperation
    }
    
    init<S: Sequence>(_ elements: S, capacity: Int) where S.Iterator.Element == T {
        self.init(capacity)
        elements.forEach { enQueue($0) }
    }
    
    public mutating func enQueue(_ element: T) {
        if isFull {
            switch overwriteOperation {
            case .ignore: return
            case .overwrite: deQueue()
            }
        }
        
        if elements.count >= capacity {
            elements[tail] = element
        } else {
            elements.append(element)
        }
        
        tail = incrementPointer(tail)
        internalCount += 1
    }
    
    @discardableResult
    public mutating func deQueue() -> T? {
        if isEmpty {
            return nil
        }
        
        let element = elements[head]
        elements[head] = nil
        head = incrementPointer(head)
        internalCount -= 1
        return element
    }
    
    public func peek() -> T? {
        return elements[head]
    }
    
    public mutating func clear() {
        head = 0
        tail = 0
        internalCount = 0
        elements.removeAll()
    }
    
    private func incrementPointer(_ pointer: Int) -> Int {
        let x = pointer + 1
        return x % capacity
    }

}

extension CircularBuffer: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return elements.description
    }

    public var debugDescription: String {
        return elements.debugDescription
    }
}

extension CircularBuffer: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(elements, capacity: elements.count)
    }
}

extension CircularBuffer: Sequence {
    public func makeIterator() -> AnyIterator<T?> {
        
        guard count > 0 else {
            return AnyIterator(IndexingIterator(_elements: [].lazy))
        }
        var data = [T?]()
        
        if head >= tail {
            data.append(contentsOf: elements[head ..< capacity])
            let end = tail - 0
            data.append(contentsOf: elements[0 ..< end])
        } else {
            data.append(contentsOf: elements[head ..< tail])
        }
        
        return AnyIterator(IndexingIterator(_elements: data.lazy))
    }
}


//public struct CircularBuffer<T> {
//
//    public enum OverwriteOperation {
//        case ignore
//        case overwrite
//    }
//
//
//    /// 队头(读指针)
//    var head: Int = 0
//
//    /// 队尾(写指针)
//    var tail: Int = 0
//
//    /// 内部存储容器
//    var elements: [T]
//
//    /// 队列长度
//    var internalCount: Int = 0
//
//    /// 覆盖选项
//    private var overwriteOperation: OverwriteOperation = .overwrite
//
//    /// 队列容量
//    public var capacity: Int {
//        get {
//            return elements.capacity
//        }
//        set {
//            elements.reserveCapacity(newValue)
//        }
//    }
//
//    /// 队列元素个数
//    public var count: Int {
//        return internalCount
//    }
//
//    /// 队列是否为空
//    public var isEmpty: Bool {
//        return count < 1
//    }
//
//    /// 队列是否已满
//    public var isFull: Bool {
//        return count == capacity
//    }
//
//    /// 创建一个环形队列
//    init() {
//        elements = [T]()
//        elements.reserveCapacity(Constant.defaultQueueCapacity)
//    }
//
//    /// 创建一个环形队列
//    ///
//    /// - Parameters:
//    ///   - size: 指定容量大小
//    ///   - overwriteOperation: 覆盖选项
//    init(_ size: Int, overwriteOperation: OverwriteOperation = .overwrite) {
//        elements = [T]()
//        elements.reserveCapacity(size)
//        self.overwriteOperation = overwriteOperation
//    }
//
//    init<S: Sequence>(_ elements: S, size: Int) where S.Iterator.Element == T {
//        self.init(size)
//        elements.forEach {
//            push($0)
//        }
//    }
//
//    /// 入队
//    ///
//    /// - Parameter element: 入队元素
//    public mutating func push(_ element: T) {
//
//        if isFull {
//            switch overwriteOperation {
//            case .ignore: return
//            /// 如果是覆盖，则先将队头元素出队
//            case .overwrite: _ = pop()
//            }
//        }
//
//        /// 如果内部存储容器中存储的元素个数还没有达到队列容量值则直接添加到容器尾， 否则，将内部存储容器中的前部元素替换
//        if elements.endIndex < capacity {
//            elements.append(element)
//        } else {
//            elements[tail] = element
//        }
//        /// 改变写指针
//        tail = incrementPointer(tail)
//        /// 元素数量加 1
//        internalCount += 1
//    }
//
//    /// 出队
//    ///
//    /// - Returns: 出队元素
//    public mutating func pop() -> T? {
//        /// 如果队列为空则直接返回 空
//        if isEmpty {
//            return nil
//        }
//        /// 先取出队头元素， 更改 读指针、元素数量 后返回出队元素
//        let element = elements[head]
//        head = incrementPointer(head)
//        internalCount -= 1
//        return element
//    }
//
//
//    /// 通过 取模运算 改变读写指针以实现环形队列
//    ///
//    /// - Parameter pointer: 读写指针
//    /// - Returns: 更改后的读写指针
//    private func incrementPointer(_ pointer: Int) -> Int {
//        return (pointer + 1) & (capacity - 1)
//    }
//
//    /// 队头元素
//    public func peek() -> T? {
//        return elements.first
//    }
//
//    /// 清空队列
//    public mutating func clear() {
//        head = 0
//        tail = 0
//        internalCount = 0
//        elements.removeAll(keepingCapacity: true)
//    }
//}
//

//
//extension CircularBuffer: CustomStringConvertible, CustomDebugStringConvertible {
//    public var description: String {
//        return elements.description
//    }
//
//    public var debugDescription: String {
//        return elements.debugDescription
//    }
//}
//
//extension CircularBuffer: ExpressibleByArrayLiteral {
//    public init(arrayLiteral elements: T...) {
//        self.init(elements, size: elements.count)
//    }
//}
//
//extension CircularBuffer: Sequence {
//
//    public func makeIterator() -> AnyIterator<T> {
//        var data = [T]()
//        if count > 0 {
//            data = [T](repeating: elements[head], count: count)
//
//            if head <= tail {
//                data[0 ..< tail - head] = elements[head ..< tail]
//            } else {
//                let front = elements.capacity - head
//                data[0 ..< front] = elements[head ..< elements.capacity]
//                if front < count {
//                    data[front + 1 ..< data.capacity] = elements[0 ..< count - front]
//                }
//            }
//        }
//        return AnyIterator(IndexingIterator(_elements: data.lazy))
//    }
//}

