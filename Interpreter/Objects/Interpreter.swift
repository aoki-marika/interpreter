//
//  Interpreter.swift
//  Interpreter
//
//  Created by Marika on 2019-11-03.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// An object for evaluating tokens from program text.
class Interpreter {

    // MARK: Public Methods

    /// Evalulate the given text and return the result.
    /// - Returns: The result of the given text.
    func evaluate(text: String) throws -> Int {
        // get all the expected tokens
        let tokenizer = Tokenizer(text: text)
        let lhsToken = try tokenizer.nextToken()
        let operatorToken = try tokenizer.nextToken()
        let rhsToken = try tokenizer.nextToken()
        let eofToken = try tokenizer.nextToken()

        // ensure the eof is valid
        guard eofToken.kind == .endOfFile else {
            throw InterpreterError.missingEndOfFile(found: eofToken.kind)
        }

        // ensure the operand kinds are valid
        guard lhsToken.kind == .number && rhsToken.kind == .number else {
            throw InterpreterError.invalidOperandKinds(lhs: lhsToken.kind, rhs: rhsToken.kind)
        }

        // ensure the operator is valid
        guard operatorToken.kind.isOperator else {
            throw InterpreterError.invalidOperatorKind(kind: operatorToken.kind)
        }

        // ensure the operand literals are valid
        guard let lhs = Int(lhsToken.literal), let rhs = Int(rhsToken.literal) else {
            throw InterpreterError.invalidOperandLiterals(lhs: lhsToken.literal, rhs: rhsToken.literal)
        }

        // perform the operation and return the result
        switch operatorToken.kind {
        case .asterisk:
            return lhs * rhs
        case .minus:
            return lhs - rhs
        case .plus:
            return lhs + rhs
        case .slash:
            return lhs / rhs
        default:
            // this should never happen, but swift requires exhaustive switches
            fatalError("attempted to perform invalid operator: \(operatorToken.kind)")
        }
    }
}
