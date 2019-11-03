//
//  InterpreterError.swift
//  Interpreter
//
//  Created by Marika on 2019-11-03.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The different errors that an interpreter can throw while evaluating.
public enum InterpreterError: Error {

    // MARK: Cases

    /// A generic error that occured while parsing the program's text.
    /// - Parameter reason: A brief description of the reason that this error occured.
    case parseError(reason: String)
}
