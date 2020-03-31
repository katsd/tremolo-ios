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
            pos.blockStackViewController.addBlankViewAt(pos.idx, size: blockView.frame.size)
        }
    }

    func dragBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {
        blockView.frame.origin.x += gesture.translation(in: nil).x
        blockView.frame.origin.y += gesture.translation(in: nil).y

        gesture.setTranslation(.zero, in: nil)
    }

    func dropBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {
        //print("dropBlock")
    }

}

extension CodeView: BlockFinder {

    func findBlockPos(blockView: UIView) -> SelectedBlockPos? {
        var l = 0
        var r = blockStackView.arrangedSubviews.count

        while r - l > 1 {
            let mid = (r + l) / 2

            if blockView.globalFrame.origin.y >= blockStackView.arrangedSubviews[mid].globalFrame.origin.y {
                l = mid
            } else {
                r = mid
            }
        }

        return SelectedBlockPos(blockStackViewController: self, idx: l)
    }

}

extension CodeView: BlockStackViewController {

    func addBlankViewAt(_ idx: Int, size: CGSize) {
        let blankView = UIView()
        blockStackView.insertArrangedSubview(blankView, at: idx)
        blankView.equalToSize(width: 0, height: size.height)
    }

    func removeBlankViewAt(_ idx: Int) {

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
