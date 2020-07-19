//
//  BlockSelectView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/11.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class BlockSelectView: UIView {

    private let tremolo: Tremolo

    private(set) var blockTemplates: [BlockTemplate]

    private let blockController: BlockController

    private let stackView: UIStackView

    init(tremolo: Tremolo, blockTemplates: [BlockTemplate], blockController: BlockController) {
        self.tremolo = tremolo

        self.blockTemplates = blockTemplates

        self.blockController = blockController

        stackView = UIStackView()
            .axis(.vertical)
            .distribution(.fill)
            .alignment(.leading)
            .spacing(10)

        super.init(frame: .zero)

        clipsToBounds(false)

        let scrollView = UIScrollView()
            .alwaysBounceVertical(true)
            .alwaysBounceHorizontal(false)
            .clipsToBounds(true)

        update(blockTemplates: blockTemplates)

        scrollView.addSubview(stackView)
        addSubview(scrollView)
        scrollView.equalTo(self)
        stackView.equalTo(scrollView, inset: .init(top: 10, left: 10, bottom: 0, right: 0))
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(blockTemplates: [BlockTemplate]) {
        self.blockTemplates = blockTemplates
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        stackView.contents(
            blockTemplates.enumerated().map { (idx, block: BlockTemplate) in
                self.blockViewInStackView(blockTemplate: block, stackView: stackView, idx: idx)
            }
        )
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

    private let blockTemplates: [BlockTemplate]

    private let blockController: BlockController

    init(tremolo: Tremolo, blockTemplates: [BlockTemplate], blockController: BlockController) {
        self.tremolo = tremolo
        self.blockTemplates = blockTemplates
        self.blockController = blockController
    }

    func makeUIView(context: Context) -> BlockSelectView {
        BlockSelectView(tremolo: tremolo, blockTemplates: blockTemplates, blockController: blockController)
    }

    func updateUIView(_ blockSelectView: BlockSelectView, context: Context) {
        if blockSelectView.blockTemplates == blockTemplates {
            return
        }
        blockSelectView.update(blockTemplates: blockTemplates)
    }
}
