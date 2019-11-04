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

    func testSingleIntegerOperations() {
        let interpreter = Interpreter()

        assertOperation(
            with: interpreter,
            lhs: 8,
            rhs: 16,
            operation: *,
            literal: "*"
        )

        assertOperation(
            with: interpreter,
            lhs: 32,
            rhs: 64,
            operation: -,
            literal: "-"
        )

        assertOperation(
            with: interpreter,
            lhs: 128,
            rhs: 256,
            operation: +,
            literal: "+"
        )

        assertOperation(
            with: interpreter,
            lhs: 512,
            rhs: 1024,
            operation: /,
            literal: "/"
        )
    }

    // MARK: Private Methods

    /// Assert that the result of the given operation is correct.
    /// - Parameter interpreter: The interpreter to perform the operation on.
    /// - Parameter lhs: The left hand side of the operation.
    /// - Parameter rhs: The right hand side of the operation.
    /// - Parameter operation: The block called to get the correct result that the interpreter result is checked against. Passed `lhs` and `rhs`.
    /// - Parameter literal: The literal of the operation in program text.
    private func assertOperation(
        with interpreter: Interpreter,
        lhs: Int,
        rhs: Int,
        operation: (Int, Int) -> Int,
        literal: String
    ) {
        let text = "\(lhs) \(literal) \(rhs)"
        var result: Int!
        XCTAssertNoThrow(result = try interpreter.evaluate(text: text))
        XCTAssertEqual(result, operation(lhs, rhs))
    }
}
