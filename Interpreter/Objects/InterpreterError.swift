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

    /// The interpreter expected one token kind, but found another.
    /// - Parameter expected: The token kind that was expected.
    /// - Parameter got: The token kind that was found.
    case unexpectedTokenKind(expected: Token.Kind, got: Token.Kind)

    /// The interpreter expected to find a factor, but found a token with an invalid kind.
    /// - Parameter kind: The kind of the token that was found.
    case invalidFactorKind(kind: Token.Kind)
}
