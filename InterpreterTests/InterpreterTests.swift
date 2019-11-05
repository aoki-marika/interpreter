//
//  InterpreterTests.swift
//  InterpreterTests
//
//  Created by Marika on 2019-11-03.
//  Copyright © 2019 Marika. All rights reserved.
//

import XCTest
@testable import Interpreter

class InterpreterTests: XCTestCase {

    // MARK: Test Cases

    func testNumberLiteral() {
        // test a number literal with no operations
        let value = Number(5328)
        assertResult(of: "\(value)", equals: value)
    }

    func testSingleNumberOperations() {
        // test different single number operations
        assertOperation(
            lhs: 8,
            rhs: 16,
            operation: *,
            literal: "*"
        )

        assertOperation(
            lhs: 32,
            rhs: 64,
            operation: -,
            literal: "-"
        )

        assertOperation(
            lhs: 128,
            rhs: 256,
            operation: +,
            literal: "+"
        )

        assertOperation(
            lhs: 512,
            rhs: 1024,
            operation: /,
            literal: "/"
        )
    }

    func testCompoundNumberOperations() {
        // test different compound number operations that arent dependent on order of operations
        assertResult(of: "9 - 5 + 3 + 11", equals: 9 - 5 + 3 + 11)
        assertResult(of: "89 + 2351 - 479 + 1", equals: 89 + 2351 - 479 + 1)
        assertResult(of: "49 - 79 - 13 + 15 + 5", equals: 49 - 79 - 13 + 15 + 5)
        assertResult(of: "-9879 - 1353 - 45", equals: -9879 - 1353 - 45)
        assertResult(of: "654 + 2 - -1456", equals: 654 + 2 - -1456)

        assertResult(of: "9 / 5 * 3 * 11", equals: 9 / 5 * 3 * 11)
        assertResult(of: "89 * 2351 / 479 * 1", equals: 89 * 2351 / 479 * 1)
        assertResult(of: "49 / 79 / 13 * 15 * 5", equals: 49 / 79 / 13 * 15 * 5)
        assertResult(of: "-9879 / 1353 / 45", equals: -9879 / 1353 / 45)
        assertResult(of: "654 * 2 / -1456", equals: 654 * 2 / -1456)
    }

    func testOrderOfNumberOperations() {
        // test different compound number operations that are dependent on order of operations
        assertResult(of: "2 + 7 * 4", equals: 2 + 7 * 4)
        assertResult(of: "7 - 8 / 4", equals: 7 - 8 / 4)
        assertResult(of: "14 + 2 * 3 - 6 / 2", equals: 14 + 2 * 3 - 6 / 2)
    }

    func testParenthesesNumberOperations() {
        // test different compound number operations that are dependent on order of operations and parentheses
        // the swift compiler cant evaluate this within the timeout, so use the final result in place
        // 7 + 3 * (10 / (12 / (3 + 1) - 1)) = 22
        assertResult(of: "7 + 3 * (10 / (12 / (3 + 1) - 1))", equals: 22)
    }

    // MARK: Private Methods

    /// Assert that the result of the given program text matches the given value.
    /// - Parameter text: The program text to evaluate.
    /// - Parameter expected: The result that is expected.
    private func assertResult(of text: String, equals expected: Number) {
        let interpreter = Interpreter(text: text)

        var result: Number!
        XCTAssertNoThrow(result = try interpreter.evaluate())
        XCTAssertEqual(result, expected)
    }

    /// Assert that the result of the given operation is correct.
    /// - Parameter lhs: The left hand side of the operation.
    /// - Parameter rhs: The right hand side of the operation.
    /// - Parameter operation: The block called to get the correct result that the interpreter result is checked against. Passed `lhs` and `rhs`.
    /// - Parameter literal: The literal of the operation in program text.
    private func assertOperation(lhs: Number, rhs: Number, operation: (Number, Number) -> Number, literal: String) {
        let text = "\(lhs) \(literal) \(rhs)"
        assertResult(of: text, equals: operation(lhs, rhs))
    }
}
