//
//  LocalVariable.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/22.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

struct LocalVariable {

    let variable: Variable

    let parent: ObjectIdentifier

    init(variable: Variable, parent: ObjectIdentifier) {
        self.variable = variable
        self.parent = parent
    }

}

extension LocalVariable: Equatable {

    static func ==(lhs: LocalVariable, rhs: LocalVariable) -> Bool {
        lhs.variable == rhs.variable &&
            lhs.parent == rhs.parent
    }

}

extension LocalVariable: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(variable)
        hasher.combine(parent)
    }

}
