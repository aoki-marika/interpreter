//
//  Token.swift
//  Interpreter
//
//  Created by Marika on 2019-11-03.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The data structure for a token within a program's text.
struct Token: CustomStringConvertible {

    // MARK: Public Properties

    /// The kind of this token.
    let kind: Kind

    /// The value of this token.
    ///
    /// What this value is depends on the kind of this token, see `Token.Kind`.
    let value: Any?

    var description: String {
        return "Token(\(kind), \(String(describing: value)))"
    }

    // MARK: Initializers

    /// - Parameter kind: The kind of this token.
    /// - Parameter value: The value of this token.
    init(kind: Kind, value: Any? = nil) {
        self.kind = kind
        self.value = value
    }
}

// MARK: Kind

extension Token {

    /// The different kinds a token can be.
    enum Kind {

        // MARK: Cases

        /// An integer literal.
        ///
        /// Value is an `Int`.
        case integer

        /// A `+` operator.
        ///
        /// Value is the `Character` of the operator.
        case plus

        /// A `-` operator.
        ///
        /// Value is the `Character` of the operator.
        case minus

        /// An `EOF` marker.
        ///
        /// Value is `nil`.
        case endOfFile
    }
}
