//
//  NumberNode.swift
//  Interpreter
//
//  Created by Marika on 2019-11-05.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// A node which contains a static number value.
class NumberNode: ValueNode {

    // MARK: Private Properties

    /// The value of this node.
    private let numberValue: Number

    // MARK: ValueNode

    var value: Number {
        return numberValue
    }

    // MARK: Initializers

    /// - Parameter value: The value of this node.
    init(value: Number) {
        self.numberValue = value
    }
}
