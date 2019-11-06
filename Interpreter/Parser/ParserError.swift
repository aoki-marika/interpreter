//
//  ParserError.swift
//  Interpreter
//
//  Created by Marika on 2019-11-04.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The different errors that can occur while a parser is parsing it's syntax tree.
enum ParserError: Error {

    // MARK: Cases

    /// The parser expected one token kind, but found another.
    /// - Parameter expected: The token kind that was expected.
    /// - Parameter got: The token kind that was found.
    case unexpectedTokenKind(expected: Token.Kind, got: Token.Kind)
}
