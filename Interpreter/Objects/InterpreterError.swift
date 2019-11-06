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

    /// The interpreter expected to find a variable, but did not.
    /// - Parameter got: The kind of the node that was found where the variable was expected.
    case expectedVariable(got: Node.Kind)

    /// The interpreter expected to find an expression, but did not.
    /// - Parameter got: The kind of the node that was found where the expression was expected.
    case expectedExpression(got: Node.Kind)

    /// The interpreter attempted to read a variable before any value was assigned to it.
    /// - Parameter name: The name of the variable that the interpreter attempted to read.
    case readUnassignedVariable(name: String)

    /// The interpreter expected to find binary operands in a node's children, but found an incorrect amount.
    /// - Parameter kind: The kind of the binary operator node.
    /// - Parameter count: The incorrect amount of children that were found.
    case invalidBinaryOperandCount(kind: Node.Kind, count: Int)

    /// The interpreter expected to find an unary operand in a node's children, but found an incorrect amount.
    /// - Parameter kind: The kind of the unary operator node.
    /// - Parameter count: The incorrect amount of children that were found.
    case invalidUnaryOperandCount(kind: Node.Kind, count: Int)

    /// The interpreter expected to find assignment operands in a node's children, but found an incorrect amount.
    /// - Parameter count: The incorrect amount of children that were found.
    case invalidAssignmentOperandCount(count: Int)
}
