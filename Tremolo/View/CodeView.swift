//
//  CodeView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/29.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class CodeView: UIView {

    private var selectedBlockPos: BlockPos? = nil

    private let blocks: [Block]

    private var blockStackView = UIStackView()

    init(blocks: [Block]) {

        self.blocks = blocks

        super.init(frame: .zero)

        let scrollView =
            UIScrollView()
                .alwaysBounceVertical(true)
                .clipsToBounds(false)
        self.addSubview(scrollView)
        scrollView.equalToEach(self, top: 0, left: 20, bottom: 0, right: 0, priority: 900)
        scrollView.lessThanOrEqualToEach(self, left: 20, priority: 1000)

        blockStackView =
            BlockStackView(blocks:
                           blocks.map {
                               BlockView(block: $0, blockController: self)
                           },
                           blockController: self)

        scrollView.addSubview(blockStackView)
        blockStackView.equalTo(scrollView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

}

extension CodeView: BlockController {

    func floatBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {
        selectedBlockPos = findBlockPos(blockView: blockView, velocity: .zero)

        blockView.translatesAutoresizingMaskIntoConstraints = true
        addSubViewKeepingGlobalFrame(blockView)

        if let pos = selectedBlockPos {
            pos.blockStackViewController.addBlankView(size: blockView.frame.size, path: (0, 0), at: pos.idx)
        }
    }

    func dragBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {
        blockView.frame.origin.x += gesture.translation(in: nil).x
        blockView.frame.origin.y += gesture.translation(in: nil).y
        gesture.setTranslation(.zero, in: nil)

        let newSelectedBlockPos = findBlockPos(blockView: blockView, velocity: gesture.velocity(in: nil))

        if selectedBlockPos != newSelectedBlockPos {
            if let pos = selectedBlockPos {
                pos.blockStackViewController.removeBlankView(path: (0, 0), at: pos.idx)
            }

            if let pos = newSelectedBlockPos {
                pos.blockStackViewController.addBlankView(size: blockView.frame.size, path: (0, 0), at: pos.idx)
            }
        }

        selectedBlockPos = newSelectedBlockPos
    }

    func dropBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {

        selectedBlockPos = findBlockPos(blockView: blockView, velocity: gesture.velocity(in: nil))

        if let pos = selectedBlockPos {
            pos.blockStackViewController.addBlockView(blockView, path: (0, 0), at: pos.idx)
        } else {
            blockView.removeFromSuperview()
        }

        selectedBlockPos = nil
    }

}

extension CodeView: BlockFinder {

    func findBlockPos(blockView: UIView, velocity: CGPoint) -> BlockPos? {

        if blockStackView.arrangedSubviews.count < 1 {
            return nil
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

        // Search Block Surrounding blockView
        let searchBlock: () -> (result: Bool, pos: BlockPos?) = {
            var l = -1
            var r = self.blockStackView.arrangedSubviews.count

            while r - l > 1 {
                let mid = (r + l) / 2

                if self.blockStackView.arrangedSubviews[mid].globalFrame.minY <= blockY {
                    l = mid
                } else {
                    r = mid
                }
            }

            if l == -1 {
                return (result: true, pos: nil)
            }

            if l == self.blockStackView.arrangedSubviews.count - 1 {
                if self.blockStackView.globalFrame.maxY <= blockY {
                    return (result: true, pos: nil)
                }
            }

            guard let surroundingBlockView = self.blockStackView.arrangedSubviews[l] as? BlockView else {
                return (result: true, pos: nil)
            }

            return (result: true, pos: surroundingBlockView.findBlockPos(blockView: blockView, velocity: velocity))
        }

        // Search index where blockView should be
        let searchIdx: () -> BlockPos = {
            let hasBlankView = self.selectedBlockPos?.blockStackViewController === self

            var l = -1
            var r = self.blockStackView.arrangedSubviews.count

            var cnt = 0

            while r - l > 1 {
                let mid = (r + l) / 2

                if self.blockStackView.arrangedSubviews[mid].globalFrame.midY < blockY {
                    l = mid
                } else {
                    r = mid
                }

                cnt += 1
            }

            if hasBlankView {
                if let pos = self.selectedBlockPos?.idx {
                    if pos < r {
                        r -= 1
                    }
                }
            }

            return BlockPos(blockStackViewController: self, path: (0, 0), idx: r)
        }

        let res = searchBlock()
        if res.pos != nil {
            return res.pos
        }

        return searchIdx()
    }

}

extension CodeView: BlockStackViewController {

    func addBlockView(_ blockView: UIView, path: (Int, Int), at idx: Int) {
        if idx < blockStackView.arrangedSubviews.count &&
               !(blockStackView.arrangedSubviews[idx] is BlockView) {
            blockStackView.arrangedSubviews[idx].removeFromSuperview()
        }

        blockStackView.addSubViewKeepingGlobalFrame(blockView)

        blockStackView.insertArrangedSubview(blockView, at: idx)

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }

    func addBlankView(size: CGSize, path: (Int, Int), at idx: Int) {
        let blankView = UIView()
        blockStackView.insertArrangedSubview(blankView, at: idx)
        blankView.equalToSize(width: 0, height: size.height)

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }

    func removeBlankView(path: (Int, Int), at idx: Int) {
        blockStackView.arrangedSubviews[idx].removeFromSuperview()

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }

}

struct CodeViewRepresentable: UIViewRepresentable {

    @Binding private var blocks: [Block]

    init(blocks: Binding<[Block]>) {
        self._blocks = blocks
    }

    func makeUIView(context: Context) -> CodeView {
        CodeView(blocks: blocks)
    }

    func updateUIView(_ uiView: CodeView, context: Context) {

    }

}
