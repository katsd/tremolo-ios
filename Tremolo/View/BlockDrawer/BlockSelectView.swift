//
//  BlockSelectView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/11.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class BlockSelectView: UIView {

    let defaultBlocks: [Block] = [
        Block(name: "default",
              type: .void,
              argTypes: [],
              argValues: [],
              contents: [[.label("Yay")]]),

        Block(name: "default+arg",
              type: .void,
              argTypes: [.custom("type")],
              argValues: [.value(Value(type: .custom(""), value: ""))],
              contents: [[.label("Nyan"), .arg(0)]]),

        Block(name: "default+arg2",
              type: .void,
              argTypes: [.custom("type")],
              argValues: [.variable(Variable(type: .custom("type"), name: "Variable"))],
              contents: [[.label("Nyan"), .arg(0)]]),

        Block(name: "default+code",
              type: .void,
              argTypes: [.code],
              argValues: [.code([])],
              contents: [[.label("Piyo")], [.arg(0)]]),
    ]

    private let blockController: BlockController

    init(blockController: BlockController) {
        self.blockController = blockController

        super.init(frame: .zero)

        clipsToBounds(false)

        let scrollView = UIScrollView()
            .alwaysBounceVertical(true)
            .alwaysBounceHorizontal(true)
            .clipsToBounds(true)

        let stackView = UIStackView()
            .axis(.vertical)
            .distribution(.fill)
            .alignment(.leading)
            .spacing(10)

        stackView.contents(
            defaultBlocks.enumerated().map { (idx, block: Block) in
                self.blockViewInStackView(block: block, stackView: stackView, idx: idx)
            }
        )

        scrollView.addSubview(stackView)
        addSubview(scrollView)
        scrollView.equalTo(self)
        stackView.equalTo(scrollView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func blockViewInStackView(block: Block, stackView: UIStackView, idx: Int) -> BlockView {
        let blockView = BlockView(block: block, blockController: self.blockController)
        blockView.isOnSelectView = true

        blockView.drag(delegate: self) { gesture in
            if gesture.state == .began {
                if !blockView.isOnSelectView {
                    return
                }
                blockView.isOnSelectView = false

                stackView.insertArrangedSubview(
                    self.blockViewInStackView(block: block, stackView: stackView, idx: idx),
                    at: idx)
            }
        }

        return blockView
    }
}

extension BlockSelectView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

struct BlockSelectViewRepresentable: UIViewRepresentable {

    private let blockController: BlockController

    init(blockController: BlockController) {
        self.blockController = blockController
    }

    func makeUIView(context: Context) -> BlockSelectView {
        BlockSelectView(blockController: blockController)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}
