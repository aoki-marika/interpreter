//
//  LexerTests.swift
//  InterpreterTests
//
//  Created by Marika on 2019-11-04.
//  Copyright © 2019 Marika. All rights reserved.
//

import XCTest
@testable import Interpreter

class LexerTests: XCTestCase {

    // MARK: Test Cases

    func testNumbers() {
        // test number tokens
        assertTokens(
            from: "1 22 333 4444 55555 666.666 -7777777 -8888.8888",
            equal: [
                Token(kind: .number, literal: "1"),
                Token(kind: .number, literal: "22"),
                Token(kind: .number, literal: "333"),
                Token(kind: .number, literal: "4444"),
                Token(kind: .number, literal: "55555"),
                Token(kind: .number, literal: "666.666"),
                Token(kind: .minus, literal: "-"),
                Token(kind: .number, literal: "7777777"),
                Token(kind: .minus, literal: "-"),
                Token(kind: .number, literal: "8888.8888"),
                Token(kind: .endOfFile),
            ]
        )

        assertTokens(
            from: "  213098 -27 31   2.10084 219 -5985.91 823.0 0.7826 -0 ",
            equal: [
                Token(kind: .number, literal: "213098"),
                Token(kind: .minus, literal: "-"),
                Token(kind: .number, literal: "27"),
                Token(kind: .number, literal: "31"),
                Token(kind: .number, literal: "2.10084"),
                Token(kind: .number, literal: "219"),
                Token(kind: .minus, literal: "-"),
                Token(kind: .number, literal: "5985.91"),
                Token(kind: .number, literal: "823.0"),
                Token(kind: .number, literal: "0.7826"),
                Token(kind: .minus, literal: "-"),
                Token(kind: .number, literal: "0"),
                Token(kind: .endOfFile),
            ]
        )
    }

    func testOperators() {
        // test operator tokens
        assertTokens(
            from: "   23984 +72673 - 615/ 69581*432168      */-7+*/     3",
            equal: [
                Token(kind: .number, literal: "23984"),
                Token(kind: .plus, literal: "+"),
                Token(kind: .number, literal: "72673"),
                Token(kind: .minus, literal: "-"),
                Token(kind: .number, literal: "615"),
                Token(kind: .slash, literal: "/"),
                Token(kind: .number, literal: "69581"),
                Token(kind: .asterisk, literal: "*"),
                Token(kind: .number, literal: "432168"),
                Token(kind: .asterisk, literal: "*"),
                Token(kind: .slash, literal: "/"),
                Token(kind: .minus, literal: "-"),
                Token(kind: .number, literal: "7"),
                Token(kind: .plus, literal: "+"),
                Token(kind: .asterisk, literal: "*"),
                Token(kind: .slash, literal: "/"),
                Token(kind: .number, literal: "3"),
                Token(kind: .endOfFile),
            ]
        )
    }

    func testParentheses() {
        // test parentheses tokens
        assertTokens(
            from: "   2(39)8)4 +72((673 )- 6)15(/ 6(958)1*43()2168   )(   */-7+*/     3",
            equal: [
                Token(kind: .number, literal: "2"),
                Token(kind: .leftParentheses, literal: "("),
                Token(kind: .number, literal: "39"),
                Token(kind: .rightParentheses, literal: ")"),
                Token(kind: .number, literal: "8"),
                Token(kind: .rightParentheses, literal: ")"),
                Token(kind: .number, literal: "4"),
                Token(kind: .plus, literal: "+"),
                Token(kind: .number, literal: "72"),
                Token(kind: .leftParentheses, literal: "("),
                Token(kind: .leftParentheses, literal: "("),
                Token(kind: .number, literal: "673"),
                Token(kind: .rightParentheses, literal: ")"),
                Token(kind: .minus, literal: "-"),
                Token(kind: .number, literal: "6"),
                Token(kind: .rightParentheses, literal: ")"),
                Token(kind: .number, literal: "15"),
                Token(kind: .leftParentheses, literal: "("),
                Token(kind: .slash, literal: "/"),
                Token(kind: .number, literal: "6"),
                Token(kind: .leftParentheses, literal: "("),
                Token(kind: .number, literal: "958"),
                Token(kind: .rightParentheses, literal: ")"),
                Token(kind: .number, literal: "1"),
                Token(kind: .asterisk, literal: "*"),
                Token(kind: .number, literal: "43"),
                Token(kind: .leftParentheses, literal: "("),
                Token(kind: .rightParentheses, literal: ")"),
                Token(kind: .number, literal: "2168"),
                Token(kind: .rightParentheses, literal: ")"),
                Token(kind: .leftParentheses, literal: "("),
                Token(kind: .asterisk, literal: "*"),
                Token(kind: .slash, literal: "/"),
                Token(kind: .minus, literal: "-"),
                Token(kind: .number, literal: "7"),
                Token(kind: .plus, literal: "+"),
                Token(kind: .asterisk, literal: "*"),
                Token(kind: .slash, literal: "/"),
                Token(kind: .number, literal: "3"),
                Token(kind: .endOfFile),
            ]
        )
    }

    func testSimpleProgram() {
        // test tokens from an extremely simple program with terrible formatting
        assertTokens(
            from: "   BEGIN a= 2;END .     ",
            equal: [
                Token(kind: .begin, literal: "BEGIN"),
                Token(kind: .id, literal: "a"),
                Token(kind: .assignment, literal: "="),
                Token(kind: .number, literal: "2"),
                Token(kind: .semicolon, literal: ";"),
                Token(kind: .end, literal: "END"),
                Token(kind: .dot, literal: "."),
                Token(kind: .endOfFile),
            ]
        )
    }

    // MARK: Private Methods

    /// Assert the the given tokens match the ones found in the given text.
    /// - Parameter text: The program text to get tokens from.
    /// - Parameter expectedTokens: The tokens that are expected to be within the given text.
    private func assertTokens(from text: String, equal expectedTokens: [Token]) {
        let lexer = Lexer(text: text)

        // iterate over all the texts tokens and ensure they match the given ones
        var expectedIndex = 0
        while true {
            // get the next token
            var token: Token!
            XCTAssertNoThrow(token = try lexer.nextToken())

            // assert that it matches the expected token
            let expectedToken = expectedTokens[expectedIndex]
            XCTAssertEqual(token, expectedToken)
            expectedIndex += 1

            // break if the lexer has finished
            if token.kind == .endOfFile {
                break
            }
        }
    }
}
