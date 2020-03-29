//
//  BlockView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class BlockView: UIView {

    init(block: Block) {
        super.init(frame: .zero)

        self.backgroundColor(.systemGray)
            .cornerRadius(5)

        let contents = blockContents(block: block)
        self.addSubview(contents)
        contents.equalTo(self, inset: .init(top: 5, left: 5, bottom: 5, right: 5))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
