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

    func testIntegerLiteral() {
        // test an integer literal with no operations
        let value = 5328
        assertResult(of: "\(value)", equals: value)
    }

    func testSingleIntegerOperations() {
        // test different single integer operations
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

    func testCompoundIntegerOperations() {
        // test different compound integer operations
        // note: only does addition + subtraction or division + multiplication right now as order of operations is not implemented
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

    // MARK: Private Methods

    /// Assert that the result of the given program text matches the given value.
    /// - Parameter text: The program text to evaluate.
    /// - Parameter expected: The result that is expected.
    private func assertResult(of text: String, equals expected: Int) {
        let interpreter = Interpreter(text: text)

        var result: Int!
        XCTAssertNoThrow(result = try interpreter.evaluate())
        XCTAssertEqual(result, expected)
    }

    /// Assert that the result of the given operation is correct.
    /// - Parameter lhs: The left hand side of the operation.
    /// - Parameter rhs: The right hand side of the operation.
    /// - Parameter operation: The block called to get the correct result that the interpreter result is checked against. Passed `lhs` and `rhs`.
    /// - Parameter literal: The literal of the operation in program text.
    private func assertOperation(lhs: Int, rhs: Int, operation: (Int, Int) -> Int, literal: String) {
        let text = "\(lhs) \(literal) \(rhs)"
        assertResult(of: text, equals: operation(lhs, rhs))
    }
}
