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
    private var result: Node?

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
    /// - Returns: The root node of this parser's text.
    func parse() throws -> Node {
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

    /// Get the factor node from the current token of this parser, and then advance the current token.
    /// - Returns: The factor node of the current token of this parser.
    private func factor() throws -> Node {
        let token = currentToken!

        switch token.kind {
        case .plus:
            // unary plus operator
            try eat(kind: .plus)
            return Node(kind: .positive, children: [try factor()])
        case .minus:
            // unary minus operator
            try eat(kind: .minus)
            return Node(kind: .negative, children: [try factor()])
        case .number:
            // return number nodes as is
            try eat(kind: .number)
            return Node(token: token)
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

    /// Get the term node for the current token of this parser, and then advance the current token.
    /// - Returns: The term node of the current token of this parser.
    private func term() throws -> Node {
        var node = try factor()

        while currentToken.kind == .asterisk || currentToken.kind == .slash {
            let token = currentToken!
            try eat(kind: token.kind)

            node = Node(
                token: token,
                children: [node, try factor()]
            )
        }

        return node
    }

    /// Get the expression node for the current token of this parser, and then advance the current token.
    /// - Returns: The expression node of the current token of this parser.
    private func expression() throws -> Node {
        var node = try term()

        while currentToken.kind == .plus || currentToken.kind == .minus {
            let token = currentToken!
            try eat(kind: token.kind)

            node = Node(
                token: token,
                children: [node, try term()]
            )
        }

        return node
    }
}
