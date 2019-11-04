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

    /// The interpreter expected to find an end of file token, but did not.
    /// - Parameter found: The token kind that was found instead of an end of file.
    case missingEndOfFile(found: Token.Kind)

    /// An operator was called with invalid operand kinds.
    /// - Parameter lhs: The token kind of the left hand side of the operation.
    /// - Parameter rhs: The token kind of the right hand side of the operation.
    case invalidOperandKinds(lhs: Token.Kind, rhs: Token.Kind)

    /// Attempted to perform an invalid token kind in place of an operator.
    case invalidOperatorKind(kind: Token.Kind)

    /// An operation was called with valid operand kinds, but the literals were invalid.
    case invalidOperandLiterals(lhs: String, rhs: String)
}
