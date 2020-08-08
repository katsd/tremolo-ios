//
//  StringValue.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 8/9/20.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class StringValue {

    public var string: String

    init(_ string: String) {
        self.string = string
    }

}

extension StringValue: Hashable {

    public static func ==(lhs: StringValue, rhs: StringValue) -> Bool {
        lhs.string == rhs.string
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(string)
    }

}

extension StringValue: CodeUnit {

    func toCode() -> String {
        string
    }

}
