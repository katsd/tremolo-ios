//
//  BlockView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class BlockView: UIView {

    private let blockController: BlockController

    init(block: Block, blockController: BlockController) {

        self.blockController = blockController

        super.init(frame: .zero)

        setStyle()

        setGesture()

        let contents = blockContents(block: block)
        self.addSubview(contents)
        contents.equalTo(self, inset: .init(top: 5, left: 5, bottom: 5, right: 5))
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setStyle() {
        self.backgroundColor(.systemGray)
            .cornerRadius(5)
    }

    private func setGesture() {
        self.isUserInteractionEnabled = true
        self.drag { gesture in
            switch gesture.state {
            case .began:
                self.blockController.floatBlock(blockView: self, gesture: gesture)
            case .changed:
                self.blockController.dragBlock(blockView: self, gesture: gesture)
            case .ended:
                self.blockController.dropBlock(blockView: self, gesture: gesture)
            default:
                break
            }
        }
    }

    private func blockContents(block: Block) -> UIView {
        UIStackView()
            .axis(.horizontal)
            .distribution(.fill)
            .alignment(.center)
            .spacing(5)
            .contents(
                block.contents.map {
                    switch $0 {
                    case let .label(text):
                        return self.label(text: text)
                    case let .arg(idx):
                        return ArgView(arg: block.argValues[idx])
                    }
                }
            )
    }

    private func label(text: String) -> UIView {
        UILabel()
            .text(text)
    }
}
