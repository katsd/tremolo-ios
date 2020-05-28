//
//  ValueView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/28.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class ValueView: UIView {

    private let tremolo: Tremolo

    private let stackView =
        UIStackView(frame: .zero)
            .axis(.horizontal)
            .distribution(.fill)
            .alignment(.center)
            .spacing(5)

    private let value: Value

    private let blockController: BlockController?

    init(tremolo: Tremolo, value: Value, blockController: BlockController?) {
        self.tremolo = tremolo

        self.value = value

        self.blockController = blockController

        super.init(frame: .zero)

        greaterThanOrEqualToSize(width: 10, height: 25)

        addSubview(stackView)
        stackView.equalTo(self, inset: .init(top: 3, left: 3, bottom: 3, right: 3))

        setStyle()

        setContents()
    }

    required init(coder: NSCoder) {
        fatalError()
    }

    private func setStyle() {
        backgroundColor(.white)
        cornerRadius(5)
    }

    private func setContents() {
        value.value.forEach { v in
            let block: Block
            switch v {
            case let .raw(str):
                block = .init(name: "str", type: .custom(""), argValues: [], contents: [[.label(str)]])
            case let .variable(variable):
                block = .init(name: "var", type: .custom(""), argValues: [], contents: [[.label(variable.name)]])
            case let .block(b):
                block = b
            }
            stackView.addArrangedSubview(BlockView(tremolo: tremolo, block: block, blockController: blockController))
        }

    }

}

extension ValueView: BlockStackViewController {

    func addBlockView(_ blockView: UIView, path: (Int, Int), at idx: Int, animation: () -> Void) {
    }

    func addBlankView(blockView: UIView, path: (Int, Int), at idx: Int, animation: () -> Void) {
    }

    func removeBlankView(path: (Int, Int), at idx: Int, animation: () -> Void) {
    }

    func findBlockPos(blockView: UIView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos? {
        return nil
    }

}

