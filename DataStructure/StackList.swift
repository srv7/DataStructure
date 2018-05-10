//
//  StackList.swift
//  DataStructure
//
//  Created by liubo on 2018/5/10.
//  Copyright © 2018年 cloudist. All rights reserved.
//

import Foundation

public struct LinkedList<Element> {
    
    fileprivate class Node<T> {
        
        /// 指向下一节点的指针
        fileprivate var next: Node<T>?
        /// 节点中存放的数据
        fileprivate var data: T
        /// 初始化一个 node， 保存数据， 下一节点指向 空
        init(data: T) {
            self.data = data
            next = nil
        }
    }
    
    /// 头节点指针
    fileprivate var head: Node<Element>? = nil
    /// 节点个数计数器
    private var _count: Int = 0
    
    /// 创建一个空链表
    public init() {}
    
    /// 从已有序列创建一个链表
    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        self.init()
        /// 将元素逐个加入链表
        sequence.forEach { push($0) }
    }
    
    public var isEmpty: Bool {
        return _count == 0
    }
    
    public var count: Int {
        return _count
    }
    
    public func peek() -> Element? {
        return head?.data
    }
    
    /// 添加一个元素到链表
    public mutating func push(_ element: Element) {
        /// 创建一个 node
        let node = Node(data: element)
        push(node)
    }
    
    private mutating func push(_ node: Node<Element>) {
        /// 将其 next 指向当前 头节点（head）(如当前没有头节点则 next 指向空， 这个节点是链表的第一个节点)
        node.next = head
        /// 然后将头节点指针只想这个节点
        head = node
        /// 计数器加1
        _count += 1
        
    }
    
    /// 删除头节点
    public mutating func pop() -> Element? {
        /// 如果链表为空，则直接返回 nil
        if isEmpty {
            return nil
        }
        /// 得到头节点数据
        let item = head?.data
        /// 将头节点 指向下一个节点
        head = head?.next
        /// 计数器减1
        _count -= 1
        /// 返回更改前的头节点数据
        return item
    }
    
    /// 通过下标获取数据
    public subscript(index: Int) -> Element {
        let node = self.node(at: index)
        return node.data
    }
    
    /// 找出对应索引的节点
    private func node(at index: Int) -> Node<Element> {
        assert(head != nil, "Empty List")
        assert(index >= 0, "index must be greater than 0")
        
        if index == 0 {
            return head!
        } else {
            var node = head?.next
            for _ in 1 ..< index {
                node = node?.next
                if node == nil {
                    break
                }
            }
            assert(node != nil, "index is out of bounds.")
            return node!
        }
    }
    
    /// 在指定索引出插入数据
    public mutating func insert(_ element: Element, at index: Int) {
        let node = Node(data: element)
        insertNode(node, at: index)
    }
    /// 在指定索引出插入节点
    private mutating func insertNode(_ node: Node<Element>, at index: Int) {
        var index = index
        if index > count - 1 {
            index = count - 1
        }
        if index == 0 {
            push(node)
        } else {
            let previous = self.node(at: index - 1)
            let next = previous.next
            node.next = next
            previous.next = node
        }
    }
    
    /// 清空链表
    public mutating func clear() {
        head = nil
    }
    /// 移除指定位置的元素
    @discardableResult
    public mutating func remove(at index: Int) -> Element? {
        assert(index <= count - 1, "index is out of bounds.")
        if index == 0 {
            return pop()
        } else if index == count - 1 {
            let previous = self.node(at: index - 1)
            let deleteNode = previous.next
            previous.next = nil
            return deleteNode?.data
        } else {
            let previous = self.node(at: index - 1)
            let deleteNode = previous.next
            let next = deleteNode?.next
            previous.next = next
            return deleteNode?.data
        }
    }
}

/// 支持使用字符串字面量创建
extension LinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension LinkedList: Sequence {
    public struct Iterator: IteratorProtocol {
        private var head: Node<Element>?
        
        fileprivate init(head: Node<Element>?) {
            self.head = head
        }
        
        public mutating func next() -> Element? {
            guard head != nil else { return nil }
            let item = head?.data
            head = head?.next
            return item
        }
    }
    public func makeIterator() -> LinkedList<Element>.Iterator {
        return Iterator(head: head)
    }
}

extension LinkedList: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        var d = "["
        var lastNode = head
        while lastNode != nil  {
            d = d + "\(lastNode!.data)"
            lastNode = lastNode?.next
            if lastNode != nil {
                d += ","
            }
        }
        d += "]"
        return d
        
    }
    
    public var debugDescription: String {
        var d = "["
        var lastNode = head
        while lastNode != nil  {
            d = d + "\(lastNode!.data)"
            lastNode = lastNode?.next
            if lastNode != nil {
                d += ","
            }
        }
        d += "]"
        return d
    }
}

public struct Stack<Element> {
    private var elements: LinkedList<Element> = LinkedList()
    
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    public var count: Int {
        return elements.count
    }
    
    public mutating func push(_ element: Element) {
        elements.push(element)
    }
    
    public mutating func pop() -> Element? {
        return elements.pop()
    }
    
    public func peek() -> Element? {
        return elements.peek()
    } 
}


extension Stack: CustomDebugStringConvertible, CustomStringConvertible {
    public var description: String {
        return elements.description
    }
    
    public var debugDescription: String {
        return elements.debugDescription
    }
}

