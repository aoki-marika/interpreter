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

    func testAddSingleDigitIntegers() {
        assertAddIntegers(lhs: 5, rhs: 7, format: "%i%@%i")
        assertAddIntegers(lhs: 1, rhs: 3, format: "%i %@ %i")
        assertAddIntegers(lhs: 9, rhs: 6, format: " %i%@ %i")
        assertAddIntegers(lhs: 8, rhs: 8, format: "%i%@%i  ")
    }

    func testAddMultiDigitIntegers() {
        assertAddIntegers(lhs: 7, rhs: 43, format: "  %i  %@  %i  ")
        assertAddIntegers(lhs: 21, rhs: 17, format: "       %i %@      %i              ")
        assertAddIntegers(lhs: 512, rhs: 3, format: "   %i%@%i   ")
        assertAddIntegers(lhs: 34, rhs: 1251, format: "%i     %@  %i")
    }

    // MARK: Private Methods

    /// Assert the result of adding the two given integers.
    /// - Parameter lhs: The left hand side of the operation.
    /// - Parameter rhs: The right hand side of the operation.
    /// - Parameter format: The custom format to use for the program text. Formatted with `lhs`, `"+"`, and `rhs`.
    private func assertAddIntegers(lhs: Int, rhs: Int, format: String) {
        let text = String(format: format, lhs, "+", rhs)
        let interpreter = Interpreter(text: text)
        XCTAssertNoThrow(try interpreter.evaluate())
        XCTAssertEqual(try? interpreter.evaluate() as? Int, lhs + rhs)
    }
}
