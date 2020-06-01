//
//  MathValueGenerator.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/06/01.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

@_functionBuilder
public enum MathValueGenerator {

    case raw(String)

    case string(String)

    case variable(Variable)

    case block(Block)

}

extension MathValueGenerator {

    public static func buildBlock(_ contents: MathValueGenerator...) -> [MathValueContent] {
        contents.reduce([]) { $0 + $1.toMathValueContents() }
    }

}

extension MathValueGenerator {

    public static func generate(_ contents: () -> MathValueGenerator) -> MathValue {
        .init(value: contents().toMathValueContents())
    }

    public static func generate(@MathValueGenerator _ contents: () -> [MathValueContent]) -> MathValue {
        .init(value: contents())
    }

}

extension MathValueGenerator {

    func toMathValueContents() -> [MathValueContent] {
        switch self {
        case let .raw(str):
            return [.raw(str)]
        case let .string(str):
            return str.map {
                MathValueContent.raw(String($0))
            }
        case let .variable(variable):
            return [.variable(variable)]
        case let .block(block):
            return [.block(block)]
        }
    }

}
