//
//  ValueView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/28.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

final class ValueView: UIView {

    private let tremolo: Tremolo

    private let stackView =
        UIStackView(frame: .zero)
            .axis(.horizontal)
            .distribution(.fill)
            .alignment(.center)
            .spacing(5)

    private let value: Value

    private let blockController: BlockController?

    private let parent: BlockStackViewController

    init(tremolo: Tremolo, value: Value, blockController: BlockController?, parent: BlockStackViewController) {
        self.tremolo = tremolo

        self.value = value

        self.blockController = blockController

        self.parent = parent

        super.init(frame: .zero)

        greaterThanOrEqualToSize(width: 10, height: 25)

        addSubview(stackView)
        stackView.equalTo(self, inset: .init(top: 4, left: 3, bottom: 4, right: 3))

        setStyle()

        setContents()
    }

    required init(coder: NSCoder) {
        fatalError()
    }

    private func setStyle() {
        //TODO: specify color from BlockView
        backgroundColor(.systemGray6)
        cornerRadius(5)
    }

    private func setContents() {
        value.blockStack.blocks.forEach { block in
            stackView.addArrangedSubview(BlockView(tremolo: tremolo, block: block, blockController: blockController))
        }
    }

}

extension ValueView: BlockStackViewController {

    func addBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> (), completion: @escaping () -> ()) {
        value.blockStack.insertBlock(blockView.block, at: idx)
        CodeView.addBlockView(stackView: stackView, blockView: blockView, at: idx, updateLayout: updateLayout, completion: completion)
    }

    func floatBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        value.blockStack.removeBlock(at: idx)
    }

    func addBlankView(blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        CodeView.addBlankView(stackView: stackView, blockView: blockView, at: idx, updateLayout: updateLayout)
    }

    func removeBlankView(path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        CodeView.removeBlankView(stackView: stackView, at: idx, updateLayout: updateLayout)
    }

    func findBlockPos(blockView: BlockView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos? {
        let blockFrame = blockView.globalFrame
        let blockX = blockFrame.minX

        if (blockX < globalFrame.minX || globalFrame.maxX < blockX) ||
               (blockFrame.maxY < globalFrame.minY || globalFrame.maxY < blockFrame.minY) {
            return nil
        }

        let searchBlock: () -> (result: Bool, pos: BlockPos?) = {
            var l = -1
            var r = self.stackView.arrangedSubviews.count

            while r - l > 1 {
                let mid = (r + l) / 2

                if self.stackView.arrangedSubviews[mid].globalFrame.minX <= blockX {
                    l = mid
                } else {
                    r = mid
                }
            }

            if l == -1 {
                return (result: false, pos: nil)
            }

            if l == self.stackView.arrangedSubviews.count - 1 {
                if self.stackView.globalFrame.maxX <= blockX {
                    return (result: false, pos: nil)
                }
            }

            guard  let surroundingBlockView = self.stackView.arrangedSubviews[l] as? BlockView else {
                return (result: false, pos: nil)
            }

            if surroundingBlockView == blockView {
                return (result: false, pos: nil)
            }

            return (result: true, pos: surroundingBlockView.findBlockPos(blockView: blockView, velocity: velocity, selectedBlockPos: selectedBlockPos))
        }

        let searchIdx: () -> BlockPos = {
            let hasBlankView: Bool
            if let pos = selectedBlockPos {
                hasBlankView = pos.blockStackViewController === self
            } else {
                hasBlankView = false
            }

            var l = -1
            var r = self.stackView.arrangedSubviews.count

            while r - l > 1 {
                let mid = (r + l) / 2

                if self.stackView.arrangedSubviews[mid].globalFrame.midX < blockX {
                    l = mid
                } else {
                    r = mid
                }
            }

            if hasBlankView {
                if let pos = selectedBlockPos?.idx {
                    if pos < r {
                        r -= 1
                    }
                }
            }

            return BlockPos(blockStackViewController: self, path: .zero, idx: r)
        }

        let res = searchBlock()
        if res.pos != nil {
            return res.pos
        }

        return searchIdx()
    }

    var parentBlock: Block? {
        parent.parentBlock
    }

}

