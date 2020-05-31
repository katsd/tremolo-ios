//
//  Value.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class Value {

    public let type: Type

    public var value: [Block]

    init(type: Type, value: [Block]) {
        self.type = type
        self.value = value
    }

}

extension Value: Hashable {

    public static func ==(lhs: Value, rhs: Value) -> Bool {
        lhs.type == rhs.type && lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(value)
    }

}

extension Value: CodeUnit {

    func toCode() -> String {
        value.reduce("") { (code, v) in
            code + v.toCode()
        }
    }

}
