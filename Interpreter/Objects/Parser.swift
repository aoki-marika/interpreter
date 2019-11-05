//
//  Parser.swift
//  Interpreter
//
//  Created by Marika on 2019-11-05.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// An object for converting program text into a syntax tree.
class Parser {

    // MARK: Private Methods

    /// The tokenizer for this parser's text.
    private let tokenizer: Tokenizer

    /// The current token this parser is processing, if any. Not set until the first call to `parse()`.
    private var currentToken: Token!

    /// The cached result of the first call to `parse()`, if any.
    private var result: ValueNode?

    // MARK: Initializers

    /// - Parameter text: The text for this parser to parse.
    init(text: String) {
        self.tokenizer = Tokenizer(text: text)
    }

    // MARK: Public Methods

    /// Parse this parser's text and return the root node.
    ///
    /// This is intended to only be called once.
    /// If this is called multiple times, then the cached result of the first parse is returned.
    /// - Returns: The node containing the result of the given text.
    func parse() throws -> ValueNode {
        if let result = result {
            return result
        }

        currentToken = try tokenizer.nextToken()
        result = try expression()
        return result!
    }

    // MARK: Private Methods

    /// Ensure that the current token of this parser matches the given kind, then advance to the next token if it does.
    /// - Parameter kind: The expected kind of the current token.
    private func eat(kind: Token.Kind) throws {
        guard currentToken.kind == kind else {
            throw ParserError.unexpectedTokenKind(expected: kind, got: currentToken.kind)
        }

        currentToken = try tokenizer.nextToken()
    }

    /// Get the value node from the current token of this parser, and then advance the current token.
    /// - Returns: The value token of the current token of this parser.
    private func factor() throws -> ValueNode {
        let token = currentToken!

        switch token.kind {
        case .number:
            // return number nodes as is
            try eat(kind: .number)
            let number = Number(token.literal)!
            return NumberNode(value: number)
        case .leftParentheses:
            // return parentheses nodes as trees
            try eat(kind: .leftParentheses)
            let node = try expression()
            try eat(kind: .rightParentheses)
            return node
        default:
            throw ParserError.invalidFactorKind(kind: token.kind)
        }
    }

    /// Get the value node of the multiplication and/or division operations at the current token of this parser, if any.
    ///
    /// This method expects the current token to be the initial result of the operations, which then all subsequent operations are performed on.
    ///
    /// If there are no operations at the current token then nothing is done to this initial result, and it is returned as is.
    /// - Returns: The value node of the multiplication and/or division operations at the current token of this parser.
    private func term() throws -> ValueNode {
        var node = try factor()

        while currentToken.kind == .asterisk || currentToken.kind == .slash {
            let token = currentToken!
            try eat(kind: token.kind)

            switch token.kind {
            case .asterisk:
                node = MultiplicationNode(
                    left: node,
                    right: try factor()
                )
            case .slash:
                node = DivisionNode(
                    left: node,
                    right: try factor()
                )
            default:
                break
            }
        }

        return node
    }

    /// Get the value node of the expression at the current token of this parser.
    /// - Returns: The value node of the operation at the current token of this parser.
    private func expression() throws -> ValueNode {
        var node = try term()

        while currentToken.kind == .plus || currentToken.kind == .minus {
            let token = currentToken!
            try eat(kind: token.kind)

            switch token.kind {
            case .plus:
                node = AdditionNode(
                    left: node,
                    right: try term()
                )
            case .minus:
                node = SubtractionNode(
                    left: node,
                    right: try term()
                )
            default:
                break
            }
        }

        return node
    }
}
