//
//  Token.swift
//  Interpreter
//
//  Created by Marika on 2019-11-03.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The data structure for a token within a program's source code.
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

        /// An `EOF` marker.
        ///
        /// Value is `nil`.
        case endOfFile
    }
}
