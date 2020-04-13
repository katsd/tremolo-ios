//
//  BlockView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class BlockView: UIView {

    var isOnSelectView = false

    private let blockController: BlockController?

    private let blockContentsStackView: BlockContentStackView

    private var blockStackViewPaths = [(Int, Int)]()

    init(block: Block, blockController: BlockController? = nil) {

        self.blockController = blockController

        self.blockContentsStackView = BlockView.blockContents(block: block, blockController: blockController)

        super.init(frame: .zero)

        setStyle()

        setGesture()

        setBlockStackViewPaths(block: block)

        self.addSubview(blockContentsStackView)
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
                    if case .code(_) = block.argValues[idx] {
                        blockStackViewPaths.append((i, j))
                    }
                }
            }
        }
    }

    static private func blockContents(block: Block, blockController: BlockController?) -> BlockContentStackView {
        let stackView = BlockContentStackView()

        for (col, sv) in block.contents.enumerated() {
            for content in sv {
                let view: UIView

                switch content {
                case let .label(text):
                    view = label(text: text)
                case let .arg(idx):
                    view = argView(arg: block.argValues[idx], blockController: blockController)
                }

                stackView.addContent(view, at: col)
            }
        }

        return stackView
    }

    static private func label(text: String) -> UIView {
        UILabel()
            .text(text)
    }

    static private func argView(arg: Argument, blockController: BlockController?) -> UIView {
        switch arg {
        case let .code(blocks):
            return BlockStackView(blocks:
                                  blocks.map {
                                      BlockView(block: $0, blockController: blockController)
                                  },
                                  blockController: blockController)
        default:
            return ArgView(arg: arg)
        }

    }
}

extension BlockView: BlockFinder {

    func findBlockPos(blockView: UIView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos? {

        let blockFrame = blockView.globalFrame
        let blockY: CGFloat

        if velocity.y > 0 {
            blockY = blockFrame.maxY
        } else if velocity.y < 0 {
            blockY = blockFrame.minY
        } else {
            blockY = blockFrame.midY
        }

        for path in blockStackViewPaths {
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

extension BlockView: BlockStackViewController {

    func addBlockView(_ blockView: UIView, path: (Int, Int), at idx: Int, animation: () -> Void) {
        guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
            return
        }

        if idx < stackView.arrangedSubviews.count &&
               !(stackView.arrangedSubviews[idx] is BlockView) {
            stackView.arrangedSubviews[idx].removeFromSuperview()
        }

        let blankView = UIView()
        stackView.insertArrangedSubview(blankView, at: idx)
        blankView.equalToSizeOf(blockView)

        self.layoutIfNeeded()

        UIView.animate(withDuration: 0.2, animations: {
            blockView.center = blankView.convertFrame(parent: blockView.superview).center
        }, completion: { _ in
            stackView.arrangedSubviews[idx].removeFromSuperview()
            stackView.insertArrangedSubview(blockView, at: idx)
        })
    }

    func addBlankView(blockView: UIView, path: (Int, Int), at idx: Int, animation: () -> Void) {
        guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
            return
        }

        let blankView = UIView()
        stackView.insertArrangedSubview(blankView, at: idx)
        blankView.equalToSizeOf(blockView)

        animation()
    }

    func removeBlankView(path: (Int, Int), at idx: Int, animation: () -> Void) {
        guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
            return
        }

        stackView.arrangedSubviews[idx].removeFromSuperview()

        animation()
    }

}
