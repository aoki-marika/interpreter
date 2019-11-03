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

        // ensure both sides are integers, as thats all that operations can be performed on right now
        guard lhs.kind == .integer, rhs.kind == .integer, let lhsValue = lhs.value as? Int, let rhsValue = rhs.value as? Int else {
            guard let operationCharacter = operation.value as? Character else {
                throw InterpreterError.parseError(reason: "Unknown operator '\(operation.kind)'")
            }

            throw InterpreterError.parseError(reason: "Operator '\(operationCharacter)' cannot be applied to operands of type '\(lhs.kind)' and '\(rhs.kind)'")
        }

        // handle the different operations
        switch operation.kind {
        case .plus:
            return lhsValue + rhsValue
        case .minus:
            return lhsValue - rhsValue
        case .asterisk:
            return lhsValue * rhsValue
        case .slash:
            return lhsValue / rhsValue
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

        // get the character at the start of the token
        var startCharacter = text[position]

        // skip past and ignore any whitespace
        while startCharacter.isWhitespace {
            // ensure that the next position is still in range
            // if its not then the text ends in whitespace, so return an eof
            position = text.index(after: position)
            guard position < text.endIndex else {
                return Token(kind: .endOfFile)
            }

            startCharacter = text[position]
        }

        // parse the token depending on what it begins with
        if startCharacter.isNumber {
            // parse out the entire integer literal
            // continually read the next digit until there are no more
            // then at the end convert them all into a single integer
            var string = ""
            while true {
                // ensure the current position is within range
                guard position < text.endIndex else {
                    break
                }

                // get the next character in the integer
                let character = text[position]
                guard character.isNumber else {
                    break
                }

                // append the character and increment the position for the next character
                string.append(character)
                position = text.index(after: position)
            }

            // parse the final value and return the new token
            let value = Int(string)
            return Token(kind: .integer, value: value)
        }
        else if startCharacter == "+" {
            // create and return the new token and increment the position for the next token
            let token = Token(kind: .plus, value: startCharacter)
            position = text.index(after: position)
            return token
        }
        else {
            // handle single character operators
            let token: Token
            switch startCharacter {
            case "+":
                token = Token(kind: .plus, value: startCharacter)
                break
            case "-":
                token = Token(kind: .minus, value: startCharacter)
                break
            case "*":
                token = Token(kind: .asterisk, value: startCharacter)
                break
            case "/":
                token = Token(kind: .slash, value: startCharacter)
                break
            default:
                throw InterpreterError.parseError(reason: "Unable to translate character '\(startCharacter)' to token")
            }

            // increment the position and return the token
            position = text.index(after: position)
            return token
        }
    }
}
