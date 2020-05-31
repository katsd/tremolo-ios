//
//  MathValue.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/28.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class MathValue {

    public var value: [MathValueContent]

    init(value: [MathValueContent]) {
        self.value = value
    }

}

extension MathValue: Hashable {

    public static func ==(lhs: MathValue, rhs: MathValue) -> Bool {
        lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

}

extension MathValue: CodeUnit {

    func toCode() -> String {
        value.reduce("") { (code, v) in
            code + v.toCode()
        }
    }

}
