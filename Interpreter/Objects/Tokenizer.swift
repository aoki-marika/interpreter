//
//  Tokenizer.swift
//  Interpreter
//
//  Created by Marika on 2019-11-03.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

class Tokenizer {

    // MARK: Private Properties

    /// The special character used for the current character when this tokenizer has reached the end of it's text.
    private let endOfFileMarker = Character("\0")

    /// The text that this tokenizer is getting tokens from.
    private let text: String

    /// The position of the current character in this tokenizer's text.
    private var currentPosition: String.Index

    /// The position that this tokenizer will read the next character from in it's text.
    private var readPosition: String.Index

    /// The current character that this tokenizer is parsing from it's text.
    /// - Note: If this is `endOfFileMarker` then this tokenizer is at the end of it's file.
    private var currentCharacter: Character

    /// Whether or not the text at the current position could be a number with a prefixed character.
    ///
    /// Used for negatives and invalid floating point literals with no beginning `0`.
    private var isPrefixedNumber: Bool {
        return peekCharacter().isNumber
    }

    /// MARK: Initializers

    /// - Parameter text: The text for this tokenizer to get tokens from.
    init(text: String) {
        self.text = text

        // reset state
        self.currentPosition = text.startIndex
        self.readPosition = text.startIndex

        // read the first character
        self.currentCharacter = endOfFileMarker
        readCharacter()
    }

    // MARK: Public Methods

    /// Attempt to read the next token from this tokenizer.
    /// - Note: If this returns `Token.Kind.endOfFile`, then all of this tokenizer's text has been tokenized.
    /// - Returns: The next token.
    func nextToken() throws -> Token {
        // skip over any whitespace
        skipWhitespace()

        // handle the different characters
        var token: Token?
        switch currentCharacter {
        case "*":
            // multiplication operator
            token = Token(kind: .asterisk, literal: String(currentCharacter))
        case "-":
            // handle negative number literals
            if isPrefixedNumber {
                let literal = try readPrefixedNumber()
                token = Token(kind: .number, literal: literal)
            }
            // else its a subtraction operator
            else {
                token = Token(kind: .minus, literal: String(currentCharacter))
            }
        case "+":
            // addition operator
            token = Token(kind: .plus, literal: String(currentCharacter))
        case "/":
            // division operator
            token = Token(kind: .slash, literal: String(currentCharacter))
        case ".":
            // handle invalid floating point literals that only have a `.` with no beginning `0`
            if isPrefixedNumber {
                let literal = try readPrefixedNumber()
                throw TokenizerError.invalidNumberLiteral(literal: literal)
            }
        case endOfFileMarker:
            // end of file marker
            token = Token(kind: .endOfFile)
        default:
            // handle positive number literals
            if currentCharacter.isNumber {
                let literal = try readNumber()
                token = Token(kind: .number, literal: literal)
            }
        }

        // read the next character for the next token
        readCharacter()

        // fallback to an invalid character error if no matching token kind was found
        guard let unwrappedToken = token else {
            throw TokenizerError.invalidCharacter(character: currentCharacter)
        }

        // return the new token
        return unwrappedToken
    }

    // MARK: Private Methods

    /// Get the next character that this tokenizer will read, without advancing the read position.
    /// - Returns: The next character this tokenizer will read.
    private func peekCharacter() -> Character {
        guard readPosition < text.endIndex else {
            return endOfFileMarker
        }

        return text[readPosition]
    }

    /// Advance this tokenizer's reading position and update it's current character.
    /// - Note: If this tokenizer has reached the end of it's text, then the current and reading positions are the end of the text, with the current character always being `endOfFileMarker`.
    private func readCharacter() {
        guard readPosition < text.endIndex else {
            currentCharacter = endOfFileMarker
            return
        }

        currentCharacter = text[readPosition]
        currentPosition = readPosition
        readPosition = text.index(after: readPosition)
    }

    /// Skip over all adjacent whitespace characters after this tokenizer's current position.
    private func skipWhitespace() {
        while currentCharacter.isWhitespace {
            readCharacter()
        }
    }

    /// Read the number literal at this tokenizer's current position.
    /// - Note: It is assumed that the existence of one is guaranteed before this method is called.
    private func readNumber() throws -> String {
        // read all the parts of the number literal
        // both digits and periods, for floating point literals
        // if there are multiple periods then break before the second one
        var string = ""
        var hasFoundPeriod = false
        while peekCharacter().isNumber || (peekCharacter() == "." && !hasFoundPeriod) {
            string.append(currentCharacter)
            if currentCharacter == "." {
                hasFoundPeriod = true
            }

            readCharacter()
        }

        string.append(currentCharacter)

        // ensure there was some form of number literal
        guard !string.isEmpty else {
            throw TokenizerError.invalidNumberLiteral(literal: string)
        }

        // ensure that the number literal has digits at the beginning and end
        // this is to avoid something like .9812 or 12. for floating point literals
        guard string.first?.isNumber ?? false && string.last?.isNumber ?? false else {
            throw TokenizerError.invalidNumberLiteral(literal: string)
        }

        // return the literal
        return string
    }

    /// Read the number literal at this tokenizer's current position that is prefixed with a single character.
    /// - Note: It is assumed that the existence of one is guaranteed before this method is called.
    private func readPrefixedNumber() throws -> String {
        // read the prefix
        let prefix = currentCharacter
        readCharacter()

        // read and join the number literal
        let number = try readNumber()
        let literal = "\(prefix)\(number)"
        return literal
    }
}
