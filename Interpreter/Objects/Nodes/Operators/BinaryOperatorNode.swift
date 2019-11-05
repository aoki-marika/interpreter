//
//  BinaryOperatorNode.swift
//  Interpreter
//
//  Created by Marika on 2019-11-05.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// A node which performs an operator on two operands (left and right) to calculate a final result.
class BinaryOperatorNode: ValueNode {

    // MARK: Internal Properties

    /// The left operand of this operation.
    internal let left: ValueNode

    /// The right operand of this operation.
    internal let right: ValueNode

    // MARK: ValueNode

    var value: Number {
        fatalError("BinaryOperatorNode subclasses must override value")
    }

    // MARK: Initializers

    /// - Parameter left: The left operand of this operation.
    /// - Parameter right: The right operand of this operation.
    required init(left: ValueNode, right: ValueNode) {
        self.left = left
        self.right = right
    }
}
