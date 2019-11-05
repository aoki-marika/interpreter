//
//  ValueNode.swift
//  Interpreter
//
//  Created by Marika on 2019-11-05.
//  Copyright © 2019 Marika. All rights reserved.
//

import Foundation

/// The protocol for any node within a syntax tree which contains or produces a value.
protocol ValueNode: Node {

    // MARK: Properties

    /// The value of this node.
    var value: Number { get }
}
