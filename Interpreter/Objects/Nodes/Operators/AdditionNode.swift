//
//  AdditionNode.swift
//  Interpreter
//
//  Created by Marika on 2019-11-05.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

class AdditionNode: BinaryOperatorNode {

    // MARK: ValueNode

    override var value: Number {
        return left.value + right.value
    }
}
