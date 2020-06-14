//
//  BlockSelectView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/11.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class BlockSelectView: UIView {

    let defaultBlocks: [BlockTemplate] = [
        BlockTemplate(
            name: "default",
            type: .void,
            argValues: [],
            contents: [[.label("Yay")]]),

        BlockTemplate(
            name: "default+arg",
            type: .void,
            argValues: [.mathValue(MathValue(value: [.raw("Yay")]))],
            contents: [[.label("Nyan"), .arg(0)]]),

        BlockTemplate(
            name: "default+arg2",
            type: .void,
            argValues: [.variable(Variable(type: .custom("type"), name: "Variable"))],
            contents: [[.label("Nyan"), .arg(0)]]),

        BlockTemplate(
            name: "default+code",
            type: .void,
            argValues: [.code(.init([]))],
            contents: [[.label("Piyo")], [.arg(0)]]),
    ]

    private let tremolo: Tremolo

    private let blockController: BlockController

    init(tremolo: Tremolo, blockController: BlockController) {
        self.tremolo = tremolo

        self.blockController = blockController

        super.init(frame: .zero)

        clipsToBounds(false)

        let scrollView = UIScrollView()
            .alwaysBounceVertical(true)
            .alwaysBounceHorizontal(false)
            .clipsToBounds(true)

        let stackView = UIStackView()
            .axis(.vertical)
            .distribution(.fill)
            .alignment(.leading)
            .spacing(10)

        stackView.contents(
            defaultBlocks.enumerated().map { (idx, block: BlockTemplate) in
                self.blockViewInStackView(block: .init(block), stackView: stackView, idx: idx)
            }
        )

        scrollView.addSubview(stackView)
        addSubview(scrollView)
        scrollView.equalTo(self)
        stackView.equalTo(scrollView, inset: .init(top: 0, left: 10, bottom: 0, right: 0))
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func blockViewInStackView(block: Block, stackView: UIStackView, idx: Int) -> BlockView {
        let blockView = BlockView(tremolo: tremolo,
                                  block: block,
                                  blockController: self.blockController,
                                  generateBlockOnSelectView: {
                                      stackView.insertArrangedSubview(
                                          self.blockViewInStackView(block: block, stackView: stackView, idx: idx),
                                          at: idx)
                                  })
        blockView.isOnSelectView = true

        return blockView
    }
}

extension BlockSelectView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

struct BlockSelectViewRepresentable: UIViewRepresentable {

    private let tremolo: Tremolo

    private let blockController: BlockController

    init(tremolo: Tremolo, blockController: BlockController) {
        self.tremolo = tremolo
        self.blockController = blockController
    }

    func makeUIView(context: Context) -> BlockSelectView {
        BlockSelectView(tremolo: tremolo, blockController: blockController)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}
