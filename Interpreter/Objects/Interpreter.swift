//
//  Interpreter.swift
//  Interpreter
//
//  Created by Marika on 2019-11-05.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// An object for interpreting and evaluating the syntax tree produced by a parser.
class Interpreter {

    // MARK: Private Properties

    /// The parser for this interpreter to interpret the syntax tree of.
    private let parser: Parser

    // MARK: Initializers

    /// - Parameter text: The program text for this interpreter to interpret.
    init(text: String) {
        self.parser = Parser(text: text)
    }

    // MARK: Public Methods

    /// Interpret the syntax tree of this interpreter's program text and return the result.
    /// - Returns: The result of this interpreter's program text.
    func interpret() throws -> Number {
        let root = try parser.parse()
        let result = try visit(node: root)
        return result
    }

    // MARK: Private Methods

    /// Traverse the given node and it's children and return the resulting value of them.
    /// - Parameter node: The node to traverse the children of.
    /// - Returns: The resulting value of the given node and it's children.
    private func visit(node: Node) throws -> Number {
        switch node.kind {
        case .addition, .subtraction, .multiplication, .division:
            // perform binary operators and return the result
            return try visitBinaryOperator(node: node)
        case .positive, .negative:
            // perform unary operators and return the result
            return try visitUnaryOperator(node: node)
        case .number(let value):
            // return numbers immediately
            return value
        }
    }

    /// Traverse the given binary operator node and perform it's operation on it's operand children.
    /// - Parameter node: The operator node to get the operands of and perform the operation of.
    /// - Returns: The resulting value of performing the given node's operation on it's operands.
    private func visitBinaryOperator(node: Node) throws -> Number {
        // ensure that the given node has the correct amount of children for binary operands
        guard node.children.count == 2 else {
            throw InterpreterError.invalidBinaryOperandCount(kind: node.kind, count: node.children.count)
        }

        // get the operands
        let left = try visit(node: node.children[0])
        let right = try visit(node: node.children[1])

        // perform the operation and return the result
        switch node.kind {
        case .addition:
            return left + right
        case .subtraction:
            return left - right
        case .multiplication:
            return left * right
        case .division:
            return left / right
        default:
            fatalError("attempted to visit invalid binary operator: \(node.kind)")
        }
    }

    /// Traverse the given unary operator node and perform it's operation on it's operand child.
    /// - Parameter node: The operator node to get the operand of and perform the operation of.
    /// - Returns: The resulting value of performing the given node's operation on it's operand.
    private func visitUnaryOperator(node: Node) throws -> Number {
        // ensure that the given node has the correct amount of children for an unary operand
        guard node.children.count == 1 else {
            throw InterpreterError.invalidUnaryOperandCount(kind: node.kind, count: node.children.count)
        }

        // get the operand
        let operand = try visit(node: node.children[0])

        // perform the operation and return the result
        switch node.kind {
        case .positive:
            return +operand
        case .negative:
            return -operand
        default:
            fatalError("attempted to visit invalid unary operator: \(node.kind)")
        }
    }
}
