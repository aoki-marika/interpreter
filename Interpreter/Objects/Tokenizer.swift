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
            // asterisk
            token = Token(kind: .asterisk, literal: String(currentCharacter))
        case "-":
            // minus
            token = Token(kind: .minus, literal: String(currentCharacter))
        case "+":
            // plus
            token = Token(kind: .plus, literal: String(currentCharacter))
        case "/":
            // slash
            token = Token(kind: .slash, literal: String(currentCharacter))
        case "(":
            // left parentheses
            token = Token(kind: .leftParentheses, literal: String(currentCharacter))
        case ")":
            // right parentheses
            token = Token(kind: .rightParentheses, literal: String(currentCharacter))
        case "=":
            // assignment
            token = Token(kind: .assignment, literal: String(currentCharacter))
        case ";":
            // semicolon
            token = Token(kind: .semicolon, literal: String(currentCharacter))
        case ".":
            // dot
            token = Token(kind: .dot, literal: String(currentCharacter))
        case endOfFileMarker:
            // end of file
            token = Token(kind: .endOfFile)
        default:
            // handle number literals
            if currentCharacter.isNumber {
                token = try readNumber()
            }
            // treat all other letters as identifiers
            else if currentCharacter.isLetter {
                token = readId()
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

    /// Read the number token at this tokenizer's current position.
    /// - Note: It is assumed that the existence of one is guaranteed before this method is called.
    /// - Returns: The number token at this tokenizer's current position.
    private func readNumber() throws -> Token {
        // read all the parts of the number literal
        // both digits and periods, for floating point literals
        // if there are multiple periods then break before the second one
        var literal = ""
        var hasFoundPeriod = false
        while peekCharacter().isNumber || (peekCharacter() == "." && !hasFoundPeriod) {
            literal.append(currentCharacter)
            if currentCharacter == "." {
                hasFoundPeriod = true
            }

            readCharacter()
        }

        literal.append(currentCharacter)

        // ensure there was some form of number literal
        guard !literal.isEmpty else {
            throw TokenizerError.invalidNumberLiteral(literal: literal)
        }

        // ensure that the number literal has digits at the beginning and end
        // this is to avoid something like .9812 or 12. for floating point literals
        guard literal.first?.isNumber ?? false && literal.last?.isNumber ?? false else {
            throw TokenizerError.invalidNumberLiteral(literal: literal)
        }

        // return the literal
        return Token(kind: .number, literal: literal)
    }

    /// Read the identifier token at the current position of this tokenizer.
    /// - Note: It is assumed that the existence of one is guaranteed before this method is called.
    /// - Returns: The identifier token at the current position of this tokenizer. Can be either a keyword or a user defined ID.
    private func readId() -> Token {
        // read the literal
        var literal = ""
        while peekCharacter().isLetter {
            literal.append(currentCharacter)
            readCharacter()
        }

        literal.append(currentCharacter)

        // map the literal to the corresponding token kind
        switch literal {
        case "BEGIN":
            return Token(kind: .begin, literal: literal)
        case "END":
            return Token(kind: .end, literal: literal)
        default:
            return Token(kind: .id, literal: literal)
        }
    }
}
