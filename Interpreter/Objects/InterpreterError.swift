//
//  InterpreterError.swift
//  Interpreter
//
//  Created by Marika on 2019-11-05.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The different errors that can occur while an interpreter is interpreting it's syntax tree.
enum InterpreterError: Error {

    // MARK: Cases

    /// The interpreter expected to find binary operands in a node's children, but found an incorrect amount.
    /// - Parameter kind: The kind of the binary operator node.
    /// - Parameter count: The incorrect amount of children that were found.
    case invalidBinaryOperandCount(kind: Node.Kind, count: Int)

    /// The interpreter expected to find an unary operand in a node's children, but found an incorrect amount.
    /// - Parameter kind: The kind of the unary operator node.
    /// - Parameter count: The incorrect amount of children that were found.
    case invalidUnaryOperandCount(kind: Node.Kind, count: Int)
}
