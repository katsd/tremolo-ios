//
//  Variable.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class Variable {

    var parentBlock: Block? = nil

    public var type: Type

    public var name: String

    init(type: Type, name: String) {
        self.type = type
        self.name = name
    }

    func copy(from variable: Variable) {
        type = variable.type
        name = variable.name
    }

    func clone() -> Variable {
        Variable(type: type, name: name)
    }

}

extension Variable: Hashable {

    public static func ==(lhs: Variable, rhs: Variable) -> Bool {
        lhs.type == rhs.type && lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(name)
    }

}

extension Variable: CodeUnit {

    func toCode() -> String {
        name
    }

}
