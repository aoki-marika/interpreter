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
        /// A number literal, either integer or floating point.
        case number

        /// The `*` operator.
        case asterisk

        /// The `-` operator.
        case minus

        /// The `+` operator.
        case plus

        /// The `/` operator.
        case slash

        /// The end of file marker.
        ///
        /// - Note: The value of this token is always empty.
        case endOfFile
    }
}

// MARK: Equatable

extension Token: Equatable {
    static func ==(lhs: Token, rhs: Token) -> Bool {
        return lhs.kind == rhs.kind && lhs.literal == rhs.literal
    }
}
