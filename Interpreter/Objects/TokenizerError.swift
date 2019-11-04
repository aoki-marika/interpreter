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

    /// The tokenizer expectected a number literal, but could not find one.
    case emptyNumberLiteral

    /// The tokenizer encountered an integer literal that was not formatted correctly.
    /// - Parameter literal: The incorrect integer literal.
    case invalidIntegerLiteral(literal: String)

    /// The tokenizer encountered a floating point literal that was not formatted correctly.
    /// - Parameter literal: The incorrect floating point literal.
    case invalidFloatingPointLiteral(literal: String)
}
