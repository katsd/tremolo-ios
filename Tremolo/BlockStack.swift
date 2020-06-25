//
//  BlockStack.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/30.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class BlockStack {

    var parentBlock: Block? = nil {
        didSet {
            blocks.forEach { $0.parent = self }
        }
    }

    private (set) var blocks: [Block]

    public init(_ blocks: [Block] = []) {
        self.blocks = blocks

        blocks.forEach { $0.parent = self }
    }

    func insertBlock(_ block: Block, at idx: Int) {
        block.parent = self
        blocks.insert(block, at: idx)
    }

    func removeBlock(at idx: Int) {
        blocks.remove(at: idx)
    }

    func block(_ block: Block) -> BlockStack {
        block.parent = self
        blocks.append(block)
        return self
    }

}

extension BlockStack: Equatable {

    public static func ==(lhs: BlockStack, rhs: BlockStack) -> Bool {
        lhs.blocks == rhs.blocks
    }

}

extension BlockStack: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocks)
    }

}

extension BlockStack: CodeUnit {

    func toCode() -> String {
        """
        {
        \(blocks.reduce("") { (code, block) in
            code + block.toCode() + "\n"
        })}
        """
    }

}

extension BlockStack: ContentStack {

    func findVariables(above selectedBlock: Block) -> [Variable] {
        var res = parentBlock?.findVariablesAboveThis() ?? [Variable]()

        for block in blocks {
            if selectedBlock === block {
                break
            }
            if let variable = block.declaredVariable {
                res.append(variable)
            }
        }

        return res
    }

}
