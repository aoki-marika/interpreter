//
//  NodeTests.swift
//  InterpreterTests
//
//  Created by Marika on 2019-11-05.
//  Copyright © 2019 Marika. All rights reserved.
//

import XCTest
@testable import Interpreter

class NodeTests: XCTestCase {

    // MARK: Test Cases

    func testBinaryOperators() {
        // 2 * 7 + 3
        let multiplication = MultiplicationNode(
            left: NumberNode(value: 2),
            right: NumberNode(value: 7)
        )

        let addition = AdditionNode(
            left: multiplication,
            right: NumberNode(value: 3)
        )

        XCTAssertEqual(addition.value, 2 * 7 + 3)

        // 31 / 19 - 2
        let division = DivisionNode(
            left: NumberNode(value: 31),
            right: NumberNode(value: 19)
        )

        let subtraction = SubtractionNode(
            left: division,
            right: NumberNode(value: 2)
        )

        XCTAssertEqual(subtraction.value, 31 / 19 - 2)
    }
}
