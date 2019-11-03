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

    func assertAddIntegers(lhs: Int, rhs: Int) {
        let interpreter = Interpreter(text: "\(lhs)+\(rhs)")
        XCTAssertNoThrow(try interpreter.evaluate())
        XCTAssertEqual(try? interpreter.evaluate() as? Int, lhs + rhs)
    }

    func testAddIntegers() {
        assertAddIntegers(lhs: 5, rhs: 7)
        assertAddIntegers(lhs: 1, rhs: 3)
        assertAddIntegers(lhs: 9, rhs: 6)
        assertAddIntegers(lhs: 8, rhs: 8)
    }
}
