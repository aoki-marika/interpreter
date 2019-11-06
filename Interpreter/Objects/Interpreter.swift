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

    /// The global scope symbol table of this interpreter, mapping variable names to values.
    /// - Note: This is temporary until a proper symbol table is implemented.
    private var globalScope = [String : Number]()

    // MARK: Initializers

    /// - Parameter text: The program text for this interpreter to interpret.
    init(text: String) {
        self.parser = Parser(text: text)
    }

    // MARK: Public Methods

    /// Interpret the syntax tree of this interpreter's program text.
    func interpret() throws {
        let root = try parser.parse()
        _ = try visit(node: root)
    }

    /// Get the variable of the given name from this interpreter's global scope, if any.
    /// - Parameter name: The name of the variable to get.
    /// - Returns: The value of the given variable, if any.
    func getVariable(name: String) -> Number? {
        return globalScope[name]
    }

    // MARK: Private Methods

    /// Traverse the given node and it's children and return the resulting value of them, if any.
    /// - Parameter node: The node to traverse the children of.
    /// - Returns: The resulting value of the given node and it's children, if any.
    private func visit(node: Node) throws -> Number? {
        // visit the different node kinds and potentially return the result
        switch node.kind {
        case .addition, .subtraction, .multiplication, .division:
            return try visitBinaryOperator(node: node)
        case .positive, .negative:
            return try visitUnaryOperator(node: node)
        case .compoundStatement:
            try visitCompoundStatement(node: node)
        case .assignmentStatement:
            try visitAssignmentStatement(node: node)
        case .emptyStatement:
            break
        case .number(let value):
            return value
        case .variable(_):
            return try visitVariable(node: node)
        }

        // if nothing has been returned yet then this node doesnt return a value
        return nil
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
        let leftNode = node.children[0]
        guard let left = try visit(node: leftNode) else {
            throw InterpreterError.expectedExpression(got: leftNode.kind)
        }

        let rightNode = node.children[1]
        guard let right = try visit(node: rightNode) else {
            throw InterpreterError.expectedExpression(got: leftNode.kind)
        }

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
        let operandNode = node.children[0]
        guard let operand = try visit(node: operandNode) else {
            throw InterpreterError.expectedExpression(got: operandNode.kind)
        }

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

    /// Traverse the given compound statement node an visit all of it's statements.
    /// - Parameter node: The compound statement node to visit the statements of.
    private func visitCompoundStatement(node: Node) throws {
        for child in node.children {
            _ = try visit(node: child)
        }
    }

    /// Traverse the given assignment statement node and perform it's operation on it's operand children.
    /// - Parameter node: The assignment statement node to get the operands of and perform the operation of.
    private func visitAssignmentStatement(node: Node) throws {
        // ensure the given node is of the correct kind
        guard node.kind == .assignmentStatement else {
            fatalError("attempted to visit invalid assignment statement: \(node.kind)")
        }

        // ensure the given node has the correct amount of children for assignment operands
        guard node.children.count == 2 else {
            throw InterpreterError.invalidAssignmentOperandCount(count: node.children.count)
        }

        // get the name of the variable to assign to
        let variableNode = node.children[0]
        let variableName: String

        switch variableNode.kind {
        case .variable(let name):
            variableName = name
        default:
            throw InterpreterError.expectedVariable(got: variableNode.kind)
        }

        // get the value to assign to the variable
        let expressionNode = node.children[1]
        guard let value = try visit(node: expressionNode) else {
            throw InterpreterError.expectedExpression(got: expressionNode.kind)
        }

        // assign the value to the variable in the global scope
        globalScope[variableName] = value
    }

    /// Get the current value for the given variable node from this interpreter's global scope.
    /// - Parameter node: The variable node to get the value of.
    /// - Returns: The current value of the variable with the name from the given node.
    private func visitVariable(node: Node) throws -> Number {
        switch node.kind {
        case .variable(let name):
            // get and return the variable value
            guard let value = getVariable(name: name) else {
                throw InterpreterError.readUnassignedVariable(name: name)
            }

            return value
        default:
            fatalError("attempted to visit invalid variable: \(node.kind)")
        }
    }
}
