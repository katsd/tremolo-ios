//
//  BlockStack.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/30.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class BlockStack {

    private (set) var blocks: [Block]

    public init(_ blocks: [Block]) {
        self.blocks = blocks
    }

    func insertBlock(_ block: Block, at idx: Int) {
        blocks.insert(block, at: idx)
    }

    func removeBlock(at idx: Int) {
        blocks.remove(at: idx)
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
