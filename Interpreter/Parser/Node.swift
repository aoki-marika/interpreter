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

        #warning("TODO: Are these names correct?")

        /// Performs a binary addition operation on the first and second children, being the left and right operands respectively.
        case addition

        /// Performs a binary subtraction operation on the first and second children, being the left and right operands respectively.
        case subtraction

        /// Performs a binary multiplication operation on the first and second children, being the left and right operands respectively.
        case multiplication

        /// Performs a binary division operation on the first and second children, being the left and right operands respectively.
        case division

        /// Performs an unary negative operation on the first child, that being the operand.
        case negative

        /// Performs an unary positive operation on the first child, that being the operand.
        case positive

        /// A `BEGIN ... END` compound statement block, with the children being the statements.
        case compoundStatement

        /// Assigns the value of the right operand expression to the keyword described by the left operand, being the second and first children respectively.
        case assignmentStatement

        /// An empty statement. Used to allow empty compound statements and the like.
        case emptyStatement

        /// Contains a static number value.
        case number(value: Number)

        /// References a variable by name.
        /// - Parameter name: The name of the variable.
        case variable(name: String)
    }
}

// MARK: Equatable

extension Node: Equatable {
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.kind == rhs.kind && lhs.children == rhs.children
    }
}
