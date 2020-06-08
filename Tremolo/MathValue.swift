//
//  MathValue.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/28.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class MathValue {

    public private(set) var contentStack: [MathValueContent]

    init(value: [MathValueContent]) {
        self.contentStack = value
    }

}

extension MathValue: Hashable {

    public static func ==(lhs: MathValue, rhs: MathValue) -> Bool {
        lhs.contentStack == rhs.contentStack
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(contentStack)
    }

}

extension MathValue {

    func insert(_ content: MathValueContent, at idx: Int) {
        contentStack.insert(content, at: idx)
    }

    func remove(at idx: Int) {
        contentStack.remove(at: idx)
    }

}

extension MathValue: CodeUnit {

    func toCode() -> String {
        contentStack.reduce("") { (code, v) in
            code + v.toCode()
        }
    }

}
