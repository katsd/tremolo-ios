//
//  CodeView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/29.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class CodeView: UIView {

    private let blocks: [Block]

    init(blocks: [Block]) {
        self.blocks = blocks
        super.init(frame: .zero)

        let scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.equalTo(self)

        let blockStackView =
            UIStackView()
                .axis(.vertical)
                .distribution(.fill)
                .spacing(5)
                .alignment(.leading)
                .contents(
                    blocks.map {
                        BlockView(block: $0)
                    }
                )

        scrollView.addSubview(blockStackView)
        blockStackView.equalTo(scrollView)
    }

    required init?(coder: NSCoder) {
        fatalError()
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
