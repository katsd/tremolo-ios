//
//  BlockView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class BlockView: UIButton {

    private let tremolo: Tremolo

    let block: Block

    var isOnSelectView = false

    var isEditable: Binding<Bool> {
        Binding(
            get: { !self.isOnSelectView },
            set: { _ in }
        )
    }

    private let style: BlockStyle

    var parent: BlockStackViewController? = nil

    private let blockController: BlockController?

    private var blockContentsStackView = BlockContentStackView()

    private var blockStackViewPaths = [BlockStackPath]()

    private var valueViewPaths = [BlockStackPath]()

    private var mathValueViewPaths = [BlockStackPath]()

    private let generateBlockOnSelectView: () -> ()

    init(tremolo: Tremolo, block: Block, blockController: BlockController? = nil, generateBlockOnSelectView: @escaping () -> () = {}) {
        self.tremolo = tremolo

        self.block = block

        self.blockController = blockController

        self.generateBlockOnSelectView = generateBlockOnSelectView

        style = block.style ?? tremolo.blockStyles[block.type] ?? BlockStyle.defaultStyle

        super.init(frame: .zero)

        setStyle()

        setGesture()

        setMenu()

        setBlockStackViewPaths(block: block)

        blockContentsStackView = blockContents(block: block)
        addSubview(blockContentsStackView)

        let spacing: CGFloat = 8
        blockContentsStackView.equalTo(self, inset: .init(top: spacing, left: spacing, bottom: spacing, right: spacing))
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setColor()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setStyle() {
        self.backgroundColor(style.color)
            .cornerRadius(style.cornerRadius)
            .shadow(style.currentShadow)
    }

    private func setColor() {
        shadow(style.currentShadow)
    }

    private func setGesture() {
        self.isUserInteractionEnabled = true

        self.drag { gesture in
            switch gesture.state {
            case .began:
                if (self.blockController?.canMoveBlock ?? false) && self.isOnSelectView {
                    self.generateBlockOnSelectView()
                    self.blockController?.floatBlock(blockView: self, gesture: gesture)
                    self.isOnSelectView = false
                    break
                }
                self.blockController?.floatBlock(blockView: self, gesture: gesture)
            case .changed:
                self.blockController?.dragBlock(blockView: self, gesture: gesture, drop: false)
            case .ended:
                self.blockController?.dragBlock(blockView: self, gesture: gesture, drop: true)
            default:
                break
            }
        }
    }

    private func setMenu() {
        let duplicate = UIAction(title: "Duplicate", image: UIImage(systemName: "plus.square.on.square")) { _ in
            self.duplicateSelf()
        }
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.deleteSelf()
        }
        let menu = UIMenu(title: "", children: [duplicate, delete])
        self.menu = menu
    }

    private func setBlockStackViewPaths(block: Block) {
        for i in 0..<block.contents.count {
            for j in 0..<block.contents[i].count {
                if case let .arg(idx) = block.contents[i][j] {
                    switch block.argValues[idx] {
                    case .value(_):
                        valueViewPaths.append(.init(row: i, col: j))
                    case .mathValue(_):
                        mathValueViewPaths.append(.init(row: i, col: j))
                    case .code(_):
                        blockStackViewPaths.append(.init(row: i, col: j))
                    default:
                        break
                    }
                }
            }
        }
    }

    private func blockContents(block: Block) -> BlockContentStackView {
        let stackView = BlockContentStackView()

        for (col, sv) in block.contents.enumerated() {
            for content in sv {
                let view: UIView

                switch content {
                case let .label(text):
                    view = label(text: text)
                case let .arg(idx):
                    view = argView(arg: block.argValues[idx])
                }

                stackView.addContent(view, at: col)
            }
        }

        return stackView
    }

    private func label(text: String) -> UIView {
        UILabel()
            .text(text)
            .textColor(style.textColor)
    }

    private func argView(arg: Argument) -> UIView {
        switch arg {
        case let .value(v):
            return ValueView(tremolo: tremolo, value: v, blockController: blockController, parent: self)

        case let .stringValue(v):
            return StringValueView(value: v, textColor: style.textColor)

        case let .mathValue(v):
            return MathValueView(tremolo: tremolo, value: v, blockController: blockController, parent: self, isEditable: isEditable)

        case let .variable(v):
            return VariableView(tremolo: tremolo, variable: v, types: [v.type], isEditable: isEditable)

        case let .code(blockStack):
            return BlockStackView(blocks:
                                  blockStack.blocks.map {
                                      BlockView(tremolo: tremolo, block: $0, blockController: self.blockController).parent(self)
                                  },
                                  blockController: blockController)
        }

    }

    private func duplicateSelf() {
        blockController?.duplicateBlock(blockView: self)
    }

    private func deleteSelf() {
        blockController?.deleteBlock(blockView: self)
    }
}

extension BlockView: BlockStackViewController {

    func addBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int, insert: Bool, updateLayout: @escaping () -> (), completion: @escaping () -> ()) {
        guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
            return
        }

        if case let .arg(aIdx) = block.contents[path.row][path.col] {
            block.argValues[aIdx].insertBlock(blockView.block, at: idx)
        }
        CodeView.addBlockView(stackView: stackView, blockView: blockView, at: idx, insert: insert, updateLayout: updateLayout, completion: completion)
    }

    func floatBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        if case let .arg(aIdx) = block.contents[path.row][path.col] {
            block.argValues[aIdx].removeBlock(at: idx)
        }
    }

    func addEmptyView(blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
            return
        }

        CodeView.addEmptyView(stackView: stackView, blockView: blockView, at: idx, updateLayout: updateLayout)
    }

    func removeBlockView(path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> (), completion: @escaping () -> ()) {
        guard  let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
            return
        }

        if case let .arg(aIdx) = block.contents[path.row][path.col] {
            block.argValues[aIdx].removeBlock(at: idx)
        }
        CodeView.removeBlockView(stackView: stackView, at: idx, updateLayout: updateLayout, completion: completion)
    }

    func removeEmptyView(path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
            return
        }

        CodeView.removeEmptyView(stackView: stackView, at: idx, updateLayout: updateLayout)
    }

    func findBlockPos(blockView: BlockView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos? {
        for path in valueViewPaths {
            guard  let valueView = blockContentsStackView.content(at: path) as? ValueView else {
                continue
            }

            let pos = valueView.findBlockPos(blockView: blockView, velocity: velocity, selectedBlockPos: selectedBlockPos)

            if pos != nil {
                return pos
            }
        }

        for path in mathValueViewPaths {
            guard  let mathValueView = blockContentsStackView.content(at: path) as? MathValueView else {
                continue
            }

            let pos = mathValueView.findBlockPos(blockView: blockView, velocity: velocity, selectedBlockPos: selectedBlockPos)

            if pos != nil {
                return pos
            }
        }

        let blockFrame = blockView.globalFrame
        let blockY: CGFloat

        if velocity.y > 0 {
            blockY = blockFrame.maxY
        } else if velocity.y < 0 {
            blockY = blockFrame.minY
        } else {
            blockY = blockFrame.midY
        }

        for path in blockStackViewPaths {
            guard let stackView = blockContentsStackView.content(at: path) as? UIStackView else {
                continue
            }

            if blockY < stackView.globalFrame.minY || stackView.globalFrame.maxY < blockY {
                continue
            }

            // Search block surrounding blockView
            let searchBlock: () -> (result: Bool, pos: BlockPos?) = {
                var l = -1
                var r = stackView.arrangedSubviews.count

                while r - l > 1 {
                    let mid = (r + l) / 2

                    if stackView.arrangedSubviews[mid].globalFrame.minY <= blockY {
                        l = mid
                    } else {
                        r = mid
                    }
                }

                if l == -1 {
                    return (result: false, pos: nil)
                }

                if l == stackView.arrangedSubviews.count - 1 {
                    if stackView.globalFrame.maxY <= blockY {
                        return (result: false, pos: nil)
                    }
                }

                guard  let surroundingBlockView = stackView.arrangedSubviews[l] as? BlockView else {
                    return (result: false, pos: nil)
                }

                if surroundingBlockView == blockView {
                    return (result: false, pos: nil)
                }

                return (result: true, pos: surroundingBlockView.findBlockPos(blockView: blockView, velocity: velocity, selectedBlockPos: selectedBlockPos))
            }

            // Search index where blockView should be
            let searchIdx: () -> BlockPos = {
                let hasEmptyView: Bool
                if let pos = selectedBlockPos {
                    hasEmptyView = pos.blockStackViewController === self && pos.path == path
                } else {
                    hasEmptyView = false
                }

                var l = -1
                var r = stackView.arrangedSubviews.count

                while r - l > 1 {
                    let mid = (r + l) / 2

                    if stackView.arrangedSubviews[mid].globalFrame.midY < blockY {
                        l = mid
                    } else {
                        r = mid
                    }
                }

                if hasEmptyView {
                    if let pos = selectedBlockPos?.idx {
                        if pos < r {
                            r -= 1
                        }
                    }
                }

                return BlockPos(blockStackViewController: self, path: path, idx: r)
            }

            let res = searchBlock()
            if res.pos != nil {
                return res.pos
            }

            return searchIdx()
        }

        return nil
    }

    var parentBlock: Block? {
        block
    }

}

extension BlockView {

    func parent(_ parent: BlockStackViewController?) -> BlockView {
        self.parent = parent
        return self
    }

}