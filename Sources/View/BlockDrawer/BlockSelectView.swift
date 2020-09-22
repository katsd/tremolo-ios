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

    private(set) var variables: [Variable]

    private let blockController: BlockController

    private let stackView: UIStackView

    init(tremolo: Tremolo, blockTemplates: [BlockTemplate], blockController: BlockController, variables: [Variable] = []) {
        self.tremolo = tremolo

        self.blockTemplates = blockTemplates

        self.variables = variables

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
        stackView.equalTo(scrollView, inset: .init(top: 20, left: 20, bottom: 20, right: 20))
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(blockTemplates: [BlockTemplate], variables: [Variable] = []) {
        self.blockTemplates = blockTemplates
        self.variables = variables

        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        stackView.contents(
            [
                blockTemplates.enumerated().map { (idx, block: BlockTemplate) in
                    self.blockViewInStackView(blockTemplate: block, stackView: stackView, idx: idx)
                },

                variables.enumerated().map { (idx, variable: Variable) in
                    self.blockViewInStackView(blockTemplate: BlockTemplate(variable), stackView: stackView, idx: blockTemplates.count + idx)
                }
            ].flatMap { $0 }
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

    private let showVariables: Bool

    init(tremolo: Tremolo, blockTemplates: [BlockTemplate], blockController: BlockController, showVariables: Bool = false) {
        self.tremolo = tremolo
        self.blockTemplates = blockTemplates
        self.blockController = blockController
        self.showVariables = showVariables
    }

    func makeUIView(context: Context) -> BlockSelectView {
        BlockSelectView(tremolo: tremolo, blockTemplates: blockTemplates, blockController: blockController, variables: showVariables ? tremolo.getAllVariables() : [])
    }

    func updateUIView(_ blockSelectView: BlockSelectView, context: Context) {
        if blockSelectView.blockTemplates == blockTemplates {
            return
        }
        blockSelectView.update(blockTemplates: blockTemplates, variables: showVariables ? tremolo.getAllVariables() : [])
    }
}
