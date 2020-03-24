//
//  Value.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public struct Value {

    public let type: Type

    public var value: String

}

extension Value: CodeUnit {

    func toCode() -> String {
        value
    }

}
