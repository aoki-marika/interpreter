//
//  Token.swift
//  Interpreter
//
//  Created by Marika on 2019-11-03.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The data structure for a token within a program's text.
struct Token {

    // MARK: Public Properties

    /// The kind of this token.
    let kind: Kind

    /// The literal used to represent this token's value.
    let literal: String

    // MARK: Initializers

    /// - Parameter kind: The kind of this token.
    /// - Parameter literal: The literal used to represent this token's value.
    init(kind: Kind, literal: String = "") {
        self.kind = kind
        self.literal = literal
    }
}

// MARK: Kind

extension Token {
    /// The different kinds a token can be.
    enum Kind {

        // MARK: Cases

        /// A number literal, either integer or floating point.
        ///
        /// - Note: Regardless of the format of the literal, all numbers  are processed as `Number`s.
        case number

        /// The `*` operator.
        case asterisk

        /// The `-` operator.
        case minus

        /// The `+` operator.
        case plus

        /// The `/` operator.
        case slash

        /// The `(` operator.
        case leftParentheses

        /// The `)` operator.
        case rightParentheses

        /// The `=` operator.
        case assignment

        /// The `;` character.
        case semicolon

        /// The `.` character.
        case dot

        /// The `BEGIN` keyword.
        case begin

        /// The `END` keyword.
        case end

        /// A user defined identifier.
        /// - Note: The token literal is the name of the identifier.
        case id

        /// The end of file marker.
        ///
        /// If this is returned from a lexer then all of the text has been analyzed.
        /// - Note: The value of this token is always empty.
        case endOfFile

        // MARK: Public Properties

        /// Whether or not this token kind is used as an operator.
        var isOperator: Bool {
            return self == .asterisk || self == .minus || self == .plus || self == .slash
        }
    }
}

// MARK: Equatable

extension Token: Equatable {
    static func ==(lhs: Token, rhs: Token) -> Bool {
        return lhs.kind == rhs.kind && lhs.literal == rhs.literal
    }
}
