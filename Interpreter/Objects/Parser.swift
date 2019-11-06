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

        // read and the root program node
        currentToken = try tokenizer.nextToken()
        let node = try program()

        // ensure the text ends in an eof
        try eat(kind: .endOfFile)

        // return the root node
        result = node
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
            // try everything else as a variable
            return try variable()
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

    /// Get the program compound statement node from the current token of this interpreter.
    /// - Returns: The program compound statement node from the current token of this interpreter.
    private func program() throws -> Node {
        // all programs are compound statements ending with a dot
        let node = try compoundStatement()
        try eat(kind: .dot)
        return node
    }

    /// Get the compound statement node from the current token of this interpreter.
    /// - Returns: The compound statement node from the current token of this interpreter.
    private func compoundStatement() throws -> Node {
        // compound statements are lists of statements wrapped by `BEGIN` and `END`
        try eat(kind: .begin)
        let children = try statementList()
        try eat(kind: .end)

        let node = Node(kind: .compoundStatement, children: children)
        return node
    }

    /// Get a list of all the semicolon-separated statement nodes from the current token of this interpreter.
    ///
    /// If there are no semicolons then just the first statement is returned.
    /// - Returns: A list of all the semicolon-separated statement nodes from the current token of this interpreter.
    private func statementList() throws -> [Node] {
        // statement lists are multiple statements separated by semicolons
        // these are used to perform multiple statements within a compound statement block
        let node = try statement()
        var results = [node]

        while currentToken.kind == .semicolon {
            try eat(kind: .semicolon)
            results.append(try statement())
        }

        if currentToken.kind == .id {
            throw ParserError.unexpectedTokenKind(expected: .end, got: .id)
        }

        return results
    }

    /// Get the statement node from the current token of this interpreter.
    /// - Returns: The statement node from the current token of this interpreter.
    private func statement() throws -> Node {
        // handle the different statement kinds depending on the first token
        switch currentToken.kind {
        case .begin:
            return try compoundStatement()
        case .id:
            return try assignmentStatement()
        default:
            return empty()
        }
    }

    /// Get the assignment statement node from the current token of this interpreter.
    /// - Returns: The assignment statement node from the current token of this interpreter.
    private func assignmentStatement() throws -> Node {
        // assign the right expressions value to the left variable
        let left = try variable()
        try eat(kind: .assignment)
        let right = try expression()

        return Node(kind: .assignmentStatement, children: [
            left,
            right
        ])
    }

    /// Get the variable node from the current token of this interpreter.
    /// - Returns: The variable node from the current token of this interpreter.
    private func variable() throws -> Node {
        // read the variable of the given name
        let name = currentToken.literal
        let node = Node(kind: .variable(name: name))
        try eat(kind: .id)
        return node
    }

    /// Get the empty statement from the current token of this interpreter.
    /// - Returns: The empty statement from the current token of this interpreter.
    private func empty() -> Node {
        return Node(kind: .emptyStatement)
    }
}
