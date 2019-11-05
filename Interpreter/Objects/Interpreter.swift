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

    // MARK: Private Methods

    /// The tokenizer for this interpreter's text.
    private let tokenizer: Tokenizer

    /// The current token this interpreter is processing, if any. Not set until the initial call to `evaluate()`.
    private var currentToken: Token!

    /// The cached result of the initial call to `evaluate()`, if any.
    private var result: Number!

    // MARK: Initializers

    /// - Parameter text: The text for this interpreter to interpret.
    init(text: String) {
        self.tokenizer = Tokenizer(text: text)
    }

    // MARK: Public Methods

    /// Evaluate the given text and return the result.
    ///
    /// This is intended to only be called once.
    /// If this is called multiple times, then the cached result of the initial evaluation is returned.
    /// - Returns: The result of the given text.
    func evaluate() throws -> Number {
        if let result = result {
            return result
        }

        currentToken = try tokenizer.nextToken()
        result = try expression()
        return result
    }

    // MARK: Private Methods

    /// Advance this interpreter's current token.
    private func nextToken() throws {
        currentToken = try tokenizer.nextToken()
    }

    /// Ensure that the current token of this interpreter matches the given kind, then advance to the next token if it does.
    /// - Parameter kind: The expected kind of the current token.
    private func eat(kind: Token.Kind) throws {
        guard currentToken.kind == kind else {
            throw InterpreterError.unexpectedTokenKind(expected: kind, got: currentToken.kind)
        }

        try nextToken()
    }

    /// Get the number value from the current token of this interpreter, and then advance the current token.
    /// - Returns: The number value of the current token of this interpreter.
    private func factor() throws -> Number {
        let token = currentToken!

        switch token.kind {
        case .number:
            // return numbers
            try eat(kind: .number)
            return Number(token.literal)!
        case .leftParentheses:
            // evaluate parentheses immediately
            try eat(kind: .leftParentheses)
            let result = try expression()
            try eat(kind: .rightParentheses)
            return result
        default:
            throw InterpreterError.invalidFactorKind(kind: token.kind)
        }
    }

    /// Get the result of the multiplication and/or division operations at the current token of this interpreter, if any.
    ///
    /// This method expects the current token to be the initial result of the operations, which then all subsequent operations are performed on.
    ///
    /// If there are no operations at the current token then nothing is done to this initial result, and it is returned as is.
    /// - Returns: The result of the multiplication and/or division operations at the current token of this interpreter.
    private func term() throws -> Number {
        var result = try factor()

        while currentToken.kind == .asterisk || currentToken.kind == .slash {
            let operatorToken = currentToken!
            try eat(kind: operatorToken.kind)

            switch operatorToken.kind {
            case .asterisk:
                result *= try factor()
            case .slash:
                result /= try factor()
            default:
                break
            }
        }

        return result
    }

    /// Get the result of the expression at the current token of this interpreter.
    /// - Returns: The result of the operation at the current token of this interpreter.
    private func expression() throws -> Number {
        var result = try term()

        while currentToken.kind == .plus || currentToken.kind == .minus {
            let operatorToken = currentToken!
            try eat(kind: operatorToken.kind)

            switch operatorToken.kind {
            case .plus:
                result += try term()
            case .minus:
                result -= try term()
            default:
                break
            }
        }

        return result
    }
}
