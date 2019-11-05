//
//  InterpreterTests.swift
//  InterpreterTests
//
//  Created by Marika on 2019-11-03.
//  Copyright © 2019 Marika. All rights reserved.
//

import XCTest
@testable import Interpreter

class ParserTests: XCTestCase {

    // MARK: Test Cases

    func testBasicArithmetic() {
        // test relatively basic arithmetic with order of operations and parentheses
        assertTree(
            from: "7 + 5",
            equals: Node(
                kind: .addition,
                children: [
                    Node(kind: .number(value: 7)),
                    Node(kind: .number(value: 5)),
                ]
            )
        )

        assertTree(
            from: "12 * 3 - 4",
            equals: Node(
                kind: .subtraction,
                children: [
                    Node(
                        kind: .multiplication,
                        children: [
                            Node(kind: .number(value: 12)),
                            Node(kind: .number(value: 3)),
                        ]
                    ),
                    Node(kind: .number(value: 4)),
                ]
            )
        )

        assertTree(
            from: "5 / (15 - 3) + 2",
            equals: Node(
                kind: .addition,
                children: [
                    Node(
                        kind: .division,
                        children: [
                            Node(kind: .number(value: 5)),
                            Node(
                                kind: .subtraction,
                                children: [
                                    Node(kind: .number(value: 15)),
                                    Node(kind: .number(value: 3)),
                                ]
                            ),
                        ]
                    ),
                    Node(kind: .number(value: 2)),
                ]
            )
        )
    }

    func testComplexArithmetic() {
        // test more complex arithmetic
        assertTree(
            from: "7 + 3 * (10 / (12 / (3 + 1) - 1))",
            equals: Node(
                kind: .addition,
                children: [
                    Node(kind: .number(value: 7)),
                    Node(
                        kind: .multiplication,
                        children: [
                            Node(kind: .number(value: 3)),
                            Node(
                                kind: .division,
                                children: [
                                    Node(kind: .number(value: 10)),
                                    Node(
                                        kind: .subtraction,
                                        children: [
                                            Node(
                                                kind: .division,
                                                children: [
                                                    Node(kind: .number(value: 12)),
                                                    Node(
                                                        kind: .addition,
                                                        children: [
                                                            Node(kind: .number(value: 3)),
                                                            Node(kind: .number(value: 1)),
                                                        ]
                                                    )
                                                ]
                                            ),
                                            Node(kind: .number(value: 1)),
                                        ]
                                    )
                                ]
                            )
                        ]
                    )
                ]
            )
        )
    }

    func testUnaryOperators() {
        // test unary operators
        assertTree(
            from: "-5 + 3",
            equals: Node(
                kind: .addition,
                children: [
                    Node(kind: .negative, children: [
                        Node(kind: .number(value: 5)),
                    ]),
                    Node(kind: .number(value: 3)),
                ]
            )
        )

        assertTree(
            from: "5 - +3",
            equals: Node(
                kind: .subtraction,
                children: [
                    Node(kind: .number(value: 5)),
                    Node(kind: .positive, children: [
                        Node(kind: .number(value: 3)),
                    ]),
                ]
            )
        )

        assertTree(
            from: "5 - - - + - 3",
            equals: Node(
                kind: .subtraction,
                children: [
                    Node(kind: .number(value: 5)),
                    Node(kind: .negative, children: [
                        Node(kind: .negative, children: [
                            Node(kind: .positive, children: [
                                Node(kind: .negative, children: [
                                    Node(kind: .number(value: 3))
                                ]),
                            ]),
                        ]),
                    ]),
                ]
            )
        )
    }

    // MARK: Private Methods

    /// Assert that the root node from the given program text matches the given node.
    /// - Parameter text: The text to get the root node from.
    /// - Parameter expectedRoot: The root node that is expected.
    private func assertTree(from text: String, equals expectedRoot: Node) {
        let parser = Parser(text: text)

        var root: Node!
        XCTAssertNoThrow(root = try parser.parse())
        XCTAssertEqual(root, expectedRoot)
    }
}
