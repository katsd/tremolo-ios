//
//  Variable.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public struct Variable: Equatable, Hashable {

    public let type: Type

    public var name: String

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
