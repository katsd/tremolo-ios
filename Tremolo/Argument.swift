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

    case variable(Variable)

    case code([Block])

    public static func ==(lhs: Argument, rhs: Argument) -> Bool {
        switch (lhs, rhs) {
        case let (.value(l), .value(r)):
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
        case let .variable(v):
            hasher.combine(v)
        case let .code(v):
            hasher.combine(v)
        }
    }
}

extension Argument: CodeUnit {

    func toCode() -> String {
        switch self {
        case let .value(value):
            return value.toCode()
        case let .variable(variable):
            return variable.toCode()
        case let .code(blocks):
            return
                """
                {
                \(blocks.reduce("") { (code, block) in
                    code + block.toCode()
                })
                }
                """
        }
    }

}
