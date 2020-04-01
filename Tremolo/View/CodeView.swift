//
//  CodeView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/29.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class CodeView: UIView {

    private var selectedBlockPos: SelectedBlockPos? = nil

    private let blocks: [Block]

    private var blockStackView = UIStackView()

    init(blocks: [Block]) {

        self.blocks = blocks

        super.init(frame: .zero)

        let scrollView =
            UIScrollView()
                .alwaysBounceVertical(true)
        self.addSubview(scrollView)
        scrollView.equalToEach(self, top: 0, left: 20, bottom: 0, right: 0, priority: 900)
        scrollView.lessThanOrEqualToEach(self, left: 20, priority: 1000)

        blockStackView =
            UIStackView()
                .axis(.vertical)
                .distribution(.fill)
                .alignment(.leading)
                .contents(
                    blocks.map {
                        BlockView(block: $0, blockController: self)
                    }
                )

        scrollView.addSubview(blockStackView)
        blockStackView.equalTo(scrollView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

}

extension CodeView: BlockController {

    func floatBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {
        selectedBlockPos = findBlockPos(blockView: blockView)

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

        let newSelectedBlockPos = findBlockPos(blockView: blockView)

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

        selectedBlockPos = findBlockPos(blockView: blockView)

        if let pos = selectedBlockPos {
            pos.blockStackViewController.addBlockView(blockView, path: (0, 0), at: pos.idx)
        } else {
            blockView.removeFromSuperview()
        }
    }

}

extension CodeView: BlockFinder {

    func findBlockPos(blockView: UIView) -> SelectedBlockPos? {
        var l = 0
        var r = blockStackView.arrangedSubviews.count

        while r - l > 1 {
            let mid = (r + l) / 2

            if blockView.globalFrame.midY >= blockStackView.arrangedSubviews[mid].globalFrame.minY {
                l = mid
            } else {
                r = mid
            }
        }

        return SelectedBlockPos(blockStackViewController: self, path: (0, 0), idx: l)
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
