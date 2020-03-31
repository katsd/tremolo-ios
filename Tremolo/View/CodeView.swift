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

    init(blocks: [Block]) {
        self.blocks = blocks
        super.init(frame: .zero)

        let scrollView =
            UIScrollView()
                .alwaysBounceVertical(true)
        self.addSubview(scrollView)
        scrollView.equalToEach(self, top: 0, left: 20, bottom: 0, right: 0, priority: 900)
        scrollView.lessThanOrEqualToEach(self, left: 20, priority: 1000)

        let blockStackView =
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
        print("floatBlock")
    }

    func dragBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {
        print("dragBlock")
    }

    func dropBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {
        print("dropBlock")
    }

}

extension CodeView: BlockFinder {

    func findBlockView(blockFrame: CGRect) -> SelectedBlockPos? {

        return nil
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
