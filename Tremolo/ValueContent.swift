//
//  ValueContent.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/28.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public enum ValueContent {

    case raw(String)

    case variable(Variable)

    case block(Block)

}

extension ValueContent: Hashable {

    public static func ==(lhs: ValueContent, rhs: ValueContent) -> Bool {
        switch (lhs, rhs) {
        case let (.raw(l), .raw(r)):
            return l == r
        case let (.variable(l), .variable(r)):
            return l == r
        case let (.block(l), .block(r)):
            return l == r
        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .raw(v):
            hasher.combine(v)
        case let .variable(v):
            hasher.combine(v)
        case let .block(v):
            hasher.combine(v)
        }
    }

}

extension ValueContent: CodeUnit {

    func toCode() -> String {
        switch self {
        case let .raw(v):
            return v
        case let .variable(v):
            return v.toCode()
        case let .block(v):
            return v.toCode()
        }
    }

}
