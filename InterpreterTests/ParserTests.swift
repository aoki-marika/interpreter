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
        assertArithmetic(
            from: "7 + 5",
            equals: Node(
                kind: .addition,
                children: [
                    Node(kind: .number(value: 7)),
                    Node(kind: .number(value: 5)),
                ]
            )
        )

        assertArithmetic(
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

        assertArithmetic(
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
        assertArithmetic(
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
        assertArithmetic(
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

        assertArithmetic(
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

        assertArithmetic(
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

    func testProgram() {
        // test parsing an actual program
        let text = """
        BEGIN
            BEGIN
                number = 2;
                a = number;
                b = 10 * a + 10 * number / 4;
                c = a - - b
            END;
            x = 11;
        END.
        """

        assertTree(
            from: text,
            equals: Node(
                kind: .compoundStatement,
                children: [
                    Node(
                        kind: .compoundStatement,
                        children: [
                            Node(
                                kind: .assignmentStatement,
                                children: [
                                    Node(kind: .variable(name: "number")),
                                    Node(kind: .number(value: 2)),
                                ]
                            ),
                            Node(
                                kind: .assignmentStatement,
                                children: [
                                    Node(kind: .variable(name: "a")),
                                    Node(kind: .variable(name: "number")),
                                ]
                            ),
                            Node(
                                kind: .assignmentStatement,
                                children: [
                                    Node(kind: .variable(name: "b")),
                                    Node(kind: .addition, children: [
                                        Node(kind: .multiplication, children: [
                                            Node(kind: .number(value: 10)),
                                            Node(kind: .variable(name: "a")),
                                        ]),
                                        Node(kind: .division, children: [
                                            Node(kind: .multiplication, children: [
                                                Node(kind: .number(value: 10)),
                                                Node(kind: .variable(name: "number")),
                                            ]),
                                            Node(kind: .number(value: 4)),
                                        ]),
                                    ]),
                                ]
                            ),
                            Node(
                                kind: .assignmentStatement,
                                children: [
                                    Node(kind: .variable(name: "c")),
                                    Node(kind: .subtraction, children: [
                                        Node(kind: .variable(name: "a")),
                                        Node(kind: .negative, children: [
                                            Node(kind: .variable(name: "b")),
                                        ]),
                                    ]),
                                ]
                            ),
                        ]
                    ),
                    Node(
                        kind: .assignmentStatement,
                        children: [
                            Node(kind: .variable(name: "x")),
                            Node(kind: .number(value: 11)),
                        ]
                    ),
                    Node(kind: .emptyStatement),
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

    /// Assert the root node of the given arithmetic text matches the given node.
    /// - Parameter arithmeticText: The arithmetic text to perform.
    /// This text is automatically wrapped in a program compound statement with an assignment statement.
    /// - Parameter expectedArithmeticRoot: The expected root node of the given arithmetic.
    /// This is automatically wrapped in the accompanying nodes for the automatic text changes.
    private func assertArithmetic(from arithmeticText: String, equals expectedArithmeticRoot: Node) {
        // create the new wrapped text and expected root
        let text = "BEGIN test = \(arithmeticText); END."
        let expectedRoot = Node(
            kind: .compoundStatement,
            children: [
                Node(
                    kind: .assignmentStatement,
                    children: [
                        Node(kind: .variable(name: "test")),
                        expectedArithmeticRoot,
                    ]
                ),
                Node(kind: .emptyStatement),
            ]
        )

        // assert the result
        assertTree(from: text, equals: expectedRoot)
    }
}
