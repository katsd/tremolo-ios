//
//  Variable.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public struct Variable {

    public let type: Type

    public var name: String

}

extension Variable: CodeUnit {

    func toCode() -> String {
        name
    }

}
