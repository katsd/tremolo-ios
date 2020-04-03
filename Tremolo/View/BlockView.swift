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

    private var blockContentsStackView: BlockContentStackView

    init(block: Block, blockController: BlockController) {

        self.blockController = blockController

        self.blockContentsStackView = BlockView.blockContents(block: block)

        super.init(frame: .zero)

        setStyle()

        setGesture()

        self.addSubview(blockContentsStackView)
        blockContentsStackView.equalTo(self, inset: .init(top: 5, left: 5, bottom: 5, right: 5))
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

    static private func blockContents(block: Block) -> BlockContentStackView {
        let stackView = BlockContentStackView()

        for (col, sv) in block.contents.enumerated() {
            for content in sv {
                let view: UIView

                switch content {
                case let .label(text):
                    view = label(text: text)
                case let .arg(idx):
                    view = ArgView(arg: block.argValues[idx])
                }

                stackView.addContent(view, at: col)
            }
        }

        return stackView
    }

    static private func label(text: String) -> UIView {
        UILabel()
            .text(text)
    }
}

extension BlockView: BlockFinder {

    func findBlockPos(blockView: UIView, velocity: CGPoint) -> SelectedBlockPos? {
        return nil
    }

}

extension BlockView: BlockStackViewController {

    func addBlockView(_ blockView: UIView, path: (Int, Int), at idx: Int) {

    }

    func addBlankView(size: CGSize, path: (Int, Int), at idx: Int) {

    }

    func removeBlankView(path: (Int, Int), at idx: Int) {

    }

}
