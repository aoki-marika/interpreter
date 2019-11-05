//
//  InterpreterError.swift
//  Interpreter
//
//  Created by Marika on 2019-11-05.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The different errors that can occur while an interpreter is interpreting it's syntax tree.
enum InterpreterError: Error {

    // MARK: Cases

    /// The interpreter expected to find binary operands in a node's children, but found an incorrect amount.
    /// - Parameter count: The incorrect amount of children that were found.
    case invalidBinaryOperandCount(count: Int)
}
