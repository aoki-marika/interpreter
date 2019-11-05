//
//  Node.swift
//  Interpreter
//
//  Created by Marika on 2019-11-05.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// A node within a syntax tree.
class Node {

    // MARK: Public Properties

    /// The kind of this node.
    let kind: Kind

    /// The children of this node.
    let children: [Node]

    // MARK: Initializers

    /// - Parameter kind: The kind of this node.
    /// - Parameter children: The children of this node.
    init(kind: Kind, children: [Node] = []) {
        self.kind = kind
        self.children = children
    }

    /// - Parameter token: The token for this node to infer it's kind from. Must be one of the allowed kinds.
    /// - Parameter children: The children of this node.
    convenience init(token: Token, children: [Node] = []) {
        switch token.kind {
        case .plus:
            self.init(kind: .addition, children: children)
        case .minus:
            self.init(kind: .subtraction, children: children)
        case .asterisk:
            self.init(kind: .multiplication, children: children)
        case .slash:
            self.init(kind: .division, children: children)
        case .number:
            let value = Number(token.literal)!
            self.init(kind: .number(value: value), children: children)
        default:
            fatalError("invalid node token kind: \(token.kind)")
        }
    }
}

// MARK: Kind

extension Node {
    /// The different kinds a node can be.
    enum Kind: Equatable {

        // MARK: Cases

        /// Performs an addition operation on the first and second children, being the left and right operands respectively.
        case addition

        /// Performs a subtraction operation on the first and second children, being the left and right operands respectively.
        case subtraction

        /// Performs a multiplication operation on the first and second children, being the left and right operands respectively.
        case multiplication

        /// Performs a division operation on the first and second children, being the left and right operands respectively.
        case division

        /// Contains a static number value.
        case number(value: Number)
    }
}

// MARK: Equatable

extension Node: Equatable {
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.kind == rhs.kind && lhs.children == rhs.children
    }
}
