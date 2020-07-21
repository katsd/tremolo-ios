//
//  Argument.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public enum Argument: Equatable, Hashable {

    case value(Value)

    case mathValue(MathValue)

    case variable(Variable)

    case code(BlockStack)

    public static func ==(lhs: Argument, rhs: Argument) -> Bool {
        switch (lhs, rhs) {
        case let (.value(l), .value(r)):
            return l == r
        case let (.mathValue(l), .mathValue(r)):
            return l == r
        case let (.variable(l), .variable(r)):
            return l == r
        case let (.code(l), .code(r)):
            return l == r
        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .value(v):
            hasher.combine(v)
        case let .mathValue(v):
            hasher.combine(v)
        case let .variable(v):
            hasher.combine(v)
        case let .code(v):
            hasher.combine(v)
        }
    }

    mutating func insertBlock(_ block: Block, at idx: Int) {
        if case var .code(blockStack) = self {
            blockStack.insertBlock(block, at: idx)
        }
    }

    mutating func removeBlock(at idx: Int) {
        if case var .code(blockStack) = self {
            blockStack.removeBlock(at: idx)
        }
    }

    func setParent(_ block: Block) {
        switch self {
        case let .value(v):
            v.parentBlock = block
        case let .mathValue(v):
            v.parentBlock = block
        case let .variable(v):
            v.parentBlock = block
        case let .code(v):
            v.parentBlock = block
        }
    }

    func clone() -> Argument {
        switch self {
        case let .value(v):
            return .value(v.clone())
        case let .mathValue(v):
            return .mathValue(v.clone())
        case let .variable(v):
            return .variable(v.clone())
        case let .code(v):
            return .code(v.clone())
        }
    }

}

extension Argument: CodeUnit {

    func toCode() -> String {
        switch self {
        case let .value(value):
            return value.toCode()
        case let .mathValue(value):
            return value.toCode()
        case let .variable(variable):
            return variable.toCode()
        case let .code(blockStack):
            return blockStack.toCode()
        }
    }

}
