//
//  Value.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class Value {

    var parentBlock: Block? = nil {
        didSet {
            blockStack.parentBlock = parentBlock
        }
    }

    let type: Type

    let blockStack: BlockStack

    public init(type: Type, blocks: [Block] = []) {
        self.type = type
        self.blockStack = .init(blocks)
    }

    func clone() -> Value {
        Value(type: type, blocks: blockStack.clone().blocks)
    }

}

extension Value: Hashable {

    public static func ==(lhs: Value, rhs: Value) -> Bool {
        lhs.type == rhs.type && lhs.blockStack == rhs.blockStack
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(blockStack)
    }

}

extension Value: CodeUnit {

    func toCode() -> String {
        blockStack.blocks.reduce("") { (code, v) in
            code + v.toCode()
        }
    }

}
