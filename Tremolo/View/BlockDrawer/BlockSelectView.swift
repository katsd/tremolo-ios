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
            argTypes: [],
            contents: [[.label("Yay")]]),

        BlockTemplate(
            name: "default+arg",
            type: .void,
            argTypes: [.mathValue],
            contents: [[.label("Nyan"), .arg(0)]]),

        BlockTemplate(
            name: "default+setVar",
            type: .void,
            argTypes: [.variable(type: .custom("variable"), name: "Variable")],
            contents: [[.label("Set"), .arg(0)]],
            declarableVariableIndex: 0),

        BlockTemplate(
            name: "default+code",
            type: .void,
            argTypes: [.code],
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
                self.blockViewInStackView(blockTemplate: block, stackView: stackView, idx: idx)
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

    func blockViewInStackView(blockTemplate: BlockTemplate, stackView: UIStackView, idx: Int) -> BlockView {
        //dump(blockTemplate, maxDepth: 4)
        let blockView = BlockView(tremolo: tremolo,
                                  block: Block(blockTemplate),
                                  blockController: self.blockController,
                                  generateBlockOnSelectView: {
                                      stackView.insertArrangedSubview(
                                          self.blockViewInStackView(blockTemplate: blockTemplate, stackView: stackView, idx: idx),
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
