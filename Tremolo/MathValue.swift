//
//  MathValue.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/28.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class MathValue {

    let type = Type.custom("value")

    var parentBlock: Block? = nil {
        didSet {
            contentStack.forEach { content in
                if case let .block(block) = content {
                    block.parent = self
                }
            }
        }
    }

    public private(set) var contentStack: [MathValueContent]

    init(value: [MathValueContent]) {
        self.contentStack = value
    }

    func clone() -> MathValue {
        MathValue(value: contentStack.map { $0.clone() })
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
        if case let .block(block) = content {
            block.parent = self
        }
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

extension MathValue: ContentStack {

    func findVariables(above selectedBlock: Block) -> [Variable] {
        var res = parentBlock?.findLocalVariablesAboveThis() ?? [Variable]()

        for content in contentStack {
            if case let .block(block) = content {
                if selectedBlock === block {
                    break
                }
                if let variable = block.declaredVariable {
                    res.append(variable.clone())
                }
            }
        }

        return res
    }

    func findIdx(of block: Block) -> Int? {
        for (idx, content) in contentStack.enumerated() {
            if case let .block(currentBlock) = content {
                if currentBlock == block {
                    return idx
                }
            }
        }
        return nil
    }

}