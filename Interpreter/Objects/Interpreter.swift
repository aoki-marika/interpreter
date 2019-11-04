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
    private var result: Int!

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
    func evaluate() throws -> Int {
        // return the cached result if there is one
        if let result = result {
            return result
        }

        // get the first token
        currentToken = try tokenizer.nextToken()

        // evaluate all the subsequent operations on the same result
        result = try term()
        while currentToken.kind.isOperator {
            // get the operator token and advance to the number token
            let operatorToken = currentToken!
            try nextToken()

            // perform the appropriate operation on the result
            #warning("TODO: This does not account for order of operations.")
            let number = try term()
            switch operatorToken.kind {
            case .asterisk:
                result *= number
            case .minus:
                result -= number
            case .plus:
                result += number
            case .slash:
                result /= number
            default:
                break
            }
        }

        // return the final result
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

    /// Get the integer value from the current token of this interpreter, and advance the current token.
    /// - Returns: The integer value of the current token of this interpreter.
    private func term() throws -> Int {
        // get the number token
        let token = currentToken!
        try eat(kind: .number)

        // parse and return the value
        guard let value = Int(token.literal) else {
            throw InterpreterError.invalidIntegerLiteral(literal: token.literal)
        }

        return value
    }
}
