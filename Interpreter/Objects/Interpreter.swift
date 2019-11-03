//
//  Interpreter.swift
//  Interpreter
//
//  Created by Marika on 2019-11-03.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// An object for interpreting and evaluating program text.
public class Interpreter {

    // MARK: Private Properties

    /// The raw text of this interpreter's program.
    private let text: String

    // MARK: Initializers

    /// - Parameter text: The program text for this interpreter to evaluate.
    public init(text: String) {
        self.text = text
    }

    // MARK: Public Methods

    /// Evaluate this interpreter's program text and return the result.
    /// - Returns: The result of evaluating this interpreter's program text.
    public func evaluate() throws -> Any? {
        // get all the parts of the text
        var position = text.startIndex
        let lhs = try getToken(at: &position)
        let operation = try getToken(at: &position)
        let rhs = try getToken(at: &position)
        let eof = try getToken(at: &position)

        // ensure there was an eof
        guard eof.kind == .endOfFile else {
            throw InterpreterError.parseError(reason: "Expected EOF but got '\(eof.kind)'")
        }

        // handle the different operations
        switch operation.kind {
        case .plus:
            // ensure both sides are integers, as thats all that can be added right now
            guard lhs.kind == .integer, rhs.kind == .integer else {
                throw InterpreterError.parseError(reason: "Operator '\(operation.value as! Character)' cannot be applied to operands of type '\(lhs.kind)' and '\(rhs.kind)'")
            }

            // return the result of the text
            return (lhs.value as! Int) + (rhs.value as! Int)
        default:
            throw InterpreterError.parseError(reason: "Unknown operation '\(operation.kind)')")
        }
    }

    // MARK: Private Methods

    /// Get the token at the given position from this interpreter's text.
    /// - Parameter position: The position of the token to get. Once the token is found then this position is incremented to the position of the next token.
    /// - Returns: The token at the given position.
    private func getToken(at position: inout String.Index) throws -> Token {
        // return eof if there is no more text to evaluate
        guard position < text.endIndex else {
            return Token(kind: .endOfFile)
        }

        // parse the token for the current character
        let character = text[position]
        let token: Token
        if character.isNumber {
            token = Token(kind: .integer, value: character.wholeNumberValue!)
        }
        else if character == "+" {
            token = Token(kind: .plus, value: character)
        }
        else {
            throw InterpreterError.parseError(reason: "Unable to translate character '\(character)' to token")
        }

        // increment the position and return the token
        position = text.index(after: position)
        return token
    }
}
