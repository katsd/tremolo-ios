//
//  BlockView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class BlockView: UIView {

    private let tremolo: Tremolo

    let block: Block

    var isOnSelectView = false

    var isEditable: Binding<Bool> {
        Binding(
            get: { !self.isOnSelectView },
            set: { _ in }
        )
    }

    private let blockController: BlockController?

    private var blockContentsStackView = BlockContentStackView()

    private var blockVStackViewPaths = [(Int, Int)]()

    private var blockHStackViewPaths = [(Int, Int)]()

    init(tremolo: Tremolo, block: Block, blockController: BlockController? = nil) {
        self.tremolo = tremolo

        self.block = block

        self.blockController = blockController

        super.init(frame: .zero)

        setStyle()

        setGesture()

        setBlockStackViewPaths(block: block)

        blockContentsStackView = blockContents(block: block)
        addSubview(blockContentsStackView)
        blockContentsStackView.equalTo(self, inset: .init(top: 5, left: 5, bottom: 5, right: 5))
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setStyle() {
        self.backgroundColor(.systemGray)
            .cornerRadius(5)
            .shadow(opacity: 0.7)
    }

    private func setGesture() {
        self.isUserInteractionEnabled = true
        self.drag { gesture in
            switch gesture.state {
            case .began:
                self.blockController?.floatBlock(blockView: self, gesture: gesture)
            case .changed:
                self.blockController?.dragBlock(blockView: self, gesture: gesture, drop: false)
            case .ended:
                self.blockController?.dragBlock(blockView: self, gesture: gesture, drop: true)
            default:
                break
            }
        }
    }

    private func setBlockStackViewPaths(block: Block) {
        for i in 0..<block.contents.count {
            for j in 0..<block.contents[i].count {
                if case let .arg(idx) = block.contents[i][j] {
                    switch block.argValues[idx] {
                    case .value(_):
                        blockHStackViewPaths.append((i, j))
                    case .code(_):
                        blockVStackViewPaths.append((i, j))
                    default:
                        break
                    }
                }
            }
        }
    }

    private func blockContents(block: Block) -> BlockContentStackView {
        let stackView = BlockContentStackView()

        for (col, sv) in block.contents.enumerated() {
            for content in sv {
                let view: UIView

                switch content {
                case let .label(text):
                    view = label(text: text)
                case let .arg(idx):
                    view = argView(arg: block.argValues[idx])
                }

                stackView.addContent(view, at: col)
            }
        }

        return stackView
    }

    private func label(text: String) -> UIView {
        UILabel()
            .text(text)
    }

    private func argView(arg: Argument) -> UIView {
        switch arg {
        case let .value(v):
            return ValueView(tremolo: tremolo, value: v, blockController: blockController)

        case let .mathValue(v):
            return MathValueView(tremolo: tremolo, value: v, isEditable: isEditable)

        case let .variable(v):
            return VariableView(tremolo: tremolo, variable: v, types: [v.type], isEditable: isEditable)

        case let .code(blocks):
            return BlockStackView(blocks:
                                  blocks.map {
                                      BlockView(tremolo: tremolo, block: $0.parent(self), blockController: self.blockController)
                                  },
                                  blockController: blockController)
        }

    }

}

extension BlockView: BlockStackViewController {

    func addBlockView(_ blockView: BlockView, path: (Int, Int), at idx: Int, animation: () -> Void) {
        guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
            return
        }

        CodeView.addBlockView(stackView: stackView, blockView: blockView, at: idx, animation: animation)
    }

    func addBlankView(blockView: BlockView, path: (Int, Int), at idx: Int, animation: () -> Void) {
        guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
            return
        }

        CodeView.addBlankView(stackView: stackView, blockView: blockView, at: idx, animation: animation)
    }

    func removeBlankView(path: (Int, Int), at idx: Int, animation: () -> Void) {
        guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
            return
        }

        CodeView.removeBlankView(stackView: stackView, at: idx, animation: animation)
    }

    func findBlockPos(blockView: BlockView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos? {
        for path in blockHStackViewPaths {
            guard  let valueView = blockContentsStackView.content(at: path) as? ValueView else {
                continue
            }

            let pos = valueView.findBlockPos(blockView: blockView, velocity: velocity, selectedBlockPos: selectedBlockPos)

            if pos != nil {
                return pos
            }
        }

        let blockFrame = blockView.globalFrame
        let blockY: CGFloat

        if velocity.y > 0 {
            blockY = blockFrame.maxY
        } else if velocity.y < 0 {
            blockY = blockFrame.minY
        } else {
            blockY = blockFrame.midY
        }

        for path in blockVStackViewPaths {
            guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
                continue
            }

            if blockY < stackView.globalFrame.minY || stackView.globalFrame.maxY < blockY {
                continue
            }

            // Search block surrounding blockView
            let searchBlock: () -> (result: Bool, pos: BlockPos?) = {
                var l = -1
                var r = stackView.arrangedSubviews.count

                while r - l > 1 {
                    let mid = (r + l) / 2

                    if stackView.arrangedSubviews[mid].globalFrame.minY <= blockY {
                        l = mid
                    } else {
                        r = mid
                    }
                }

                if l == -1 {
                    return (result: false, pos: nil)
                }

                if l == stackView.arrangedSubviews.count - 1 {
                    if stackView.globalFrame.maxY <= blockY {
                        return (result: false, pos: nil)
                    }
                }

                guard  let surroundingBlockView = stackView.arrangedSubviews[l] as? BlockView else {
                    return (result: false, pos: nil)
                }

                if surroundingBlockView == blockView {
                    return (result: false, pos: nil)
                }

                return (result: true, pos: surroundingBlockView.findBlockPos(blockView: blockView, velocity: velocity, selectedBlockPos: selectedBlockPos))
            }

            // Search index where blockView should be
            let searchIdx: () -> BlockPos = {
                let hasBlankView: Bool
                if let pos = selectedBlockPos {
                    hasBlankView = pos.blockStackViewController === self && pos.path == path
                } else {
                    hasBlankView = false
                }

                var l = -1
                var r = stackView.arrangedSubviews.count

                while r - l > 1 {
                    let mid = (r + l) / 2

                    if stackView.arrangedSubviews[mid].globalFrame.midY < blockY {
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

                return BlockPos(blockStackViewController: self, path: path, idx: r)
            }

            let res = searchBlock()
            if res.pos != nil {
                return res.pos
            }

            return searchIdx()
        }

        return nil
    }

}
