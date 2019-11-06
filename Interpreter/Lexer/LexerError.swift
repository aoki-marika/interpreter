//
//  LexerError.swift
//  Interpreter
//
//  Created by Marika on 2019-11-04.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The different errors that can occur while a lexer is analyzing.
enum LexerError: Error {

    // MARK: Cases

    /// The lexer encountered an invalid character in it's text.
    /// - Parameter character: The invalid character that was found.
    case invalidCharacter(character: Character)

    /// The lexer encountered a number literal that was not formatted correctly.
    /// - Parameter literal: The incorrect number literal.
    case invalidNumberLiteral(literal: String)
}
