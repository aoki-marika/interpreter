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

    func testSubtractIntegers() {
        assertSubtractIntegers(lhs: 5, rhs: 7, format: "%i%@%i")
        assertSubtractIntegers(lhs: 1, rhs: 3, format: "%i %@ %i")
        assertSubtractIntegers(lhs: 9, rhs: 6, format: " %i%@ %i")
        assertSubtractIntegers(lhs: 8, rhs: 8, format: "%i%@%i  ")
        assertSubtractIntegers(lhs: 7, rhs: 43, format: "  %i  %@  %i  ")
        assertSubtractIntegers(lhs: 21, rhs: 17, format: "       %i %@      %i              ")
        assertSubtractIntegers(lhs: 512, rhs: 3, format: "   %i%@%i   ")
        assertSubtractIntegers(lhs: 34, rhs: 1251, format: "%i     %@  %i")
    }

    func testMultiplyIntegers() {
        assertMultiplyIntegers(lhs: 5, rhs: 7, format: "%i%@%i")
        assertMultiplyIntegers(lhs: 1, rhs: 3, format: "%i %@ %i")
        assertMultiplyIntegers(lhs: 9, rhs: 6, format: " %i%@ %i")
        assertMultiplyIntegers(lhs: 8, rhs: 8, format: "%i%@%i  ")
        assertMultiplyIntegers(lhs: 7, rhs: 43, format: "  %i  %@  %i  ")
        assertMultiplyIntegers(lhs: 21, rhs: 17, format: "       %i %@      %i              ")
        assertMultiplyIntegers(lhs: 512, rhs: 3, format: "   %i%@%i   ")
        assertMultiplyIntegers(lhs: 34, rhs: 1251, format: "%i     %@  %i")
    }

    func testDivideIntegers() {
        assertDivideIntegers(lhs: 5, rhs: 7, format: "%i%@%i")
        assertDivideIntegers(lhs: 1, rhs: 3, format: "%i %@ %i")
        assertDivideIntegers(lhs: 9, rhs: 6, format: " %i%@ %i")
        assertDivideIntegers(lhs: 8, rhs: 8, format: "%i%@%i  ")
        assertDivideIntegers(lhs: 7, rhs: 43, format: "  %i  %@  %i  ")
        assertDivideIntegers(lhs: 21, rhs: 17, format: "       %i %@      %i              ")
        assertDivideIntegers(lhs: 512, rhs: 3, format: "   %i%@%i   ")
        assertDivideIntegers(lhs: 34, rhs: 1251, format: "%i     %@  %i")
    }

    // MARK: Private Methods

    /// Assert the result of performing the given operation on the given operands.
    /// - Parameter lhs: The left hand side of the operation.
    /// - Parameter rhs: The right hand side of the operation.
    /// - Parameter operation: The block called to perform the operation. Passed `lhs` and `rhs`.
    /// - Parameter literal: The literal used to perform the given operation inside of the program text.
    /// - Parameter format: The custom format to use for the program text. Formatted with `lhs`, `literal`, and `rhs`.
    private func assertOperation(lhs: Int, rhs: Int, operation: (Int, Int) -> Int, literal: String, format: String) {
        let text = String(format: format, lhs, literal, rhs)
        print(text)
        let interpreter = Interpreter(text: text)
        XCTAssertNoThrow(try interpreter.evaluate())
        XCTAssertEqual(try? interpreter.evaluate() as? Int, operation(lhs, rhs))
    }

    /// Calls `assertOperation(lhs:rhs:operation:literal:format)` for an addition operation.
    private func assertAddIntegers(lhs: Int, rhs: Int, format: String) {
        assertOperation(
            lhs: lhs,
            rhs: rhs,
            operation: +,
            literal: "+",
            format: format
        )
    }

    /// Calls `assertOperation(lhs:rhs:operation:literal:format)` for a subtraction operation.
    private func assertSubtractIntegers(lhs: Int, rhs: Int, format: String) {
        assertOperation(
            lhs: lhs,
            rhs: rhs,
            operation: -,
            literal: "-",
            format: format
        )
    }

    /// Calls `assertOperation(lhs:rhs:operation:literal:format)` for a multiplication operation.
    private func assertMultiplyIntegers(lhs: Int, rhs: Int, format: String) {
        assertOperation(
            lhs: lhs,
            rhs: rhs,
            operation: *,
            literal: "*",
            format: format
        )
    }

    /// Calls `assertOperation(lhs:rhs:operation:literal:format)` for a division operation.
    private func assertDivideIntegers(lhs: Int, rhs: Int, format: String) {
        assertOperation(
            lhs: lhs,
            rhs: rhs,
            operation: /,
            literal: "/",
            format: format
        )
    }
}
