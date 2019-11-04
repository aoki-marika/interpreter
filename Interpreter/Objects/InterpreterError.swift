//
//  InterpreterError.swift
//  Interpreter
//
//  Created by Marika on 2019-11-04.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The different errors that can occur in an interpreter while evaluating.
enum InterpreterError: Error {

    // MARK: Cases

    /// The interpreter expected one token kind, but got another.
    /// - Parameter expected: The token kind that was expected.
    /// - Parameter got: The token kind that was found.
    case unexpectedTokenKind(expected: Token.Kind, got: Token.Kind)

    /// The interpreter expected an integer literal, but got a floating point literal.
    /// - Note: This is a temporary error while the interpreter only supports integers.
    /// - Parameter literal: The float literal that was found instead of an integer literal.
    case invalidIntegerLiteral(literal: String)
}
