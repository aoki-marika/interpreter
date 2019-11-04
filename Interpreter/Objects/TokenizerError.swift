//
//  TokenizerError.swift
//  Interpreter
//
//  Created by Marika on 2019-11-04.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The different errors that can occur while a tokenizer is reading it's text.
enum TokenizerError: Error {

    // MARK: Cases

    /// The tokenizer encountered an invalid character in it's text.
    /// - Parameter character:
    case invalidCharacter(character: Character)

    /// The tokenizer encountered a number literal that was not formatted correctly.
    /// - Parameter literal: The incorrect number literal.
    case invalidNumberLiteral(literal: String)
}
