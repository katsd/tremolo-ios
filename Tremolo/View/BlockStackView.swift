//
//  BlockStackView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/05.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class BlockStackView: UIStackView {

    init(blocks: [UIView], blockController: BlockController) {
        super.init(frame: .zero)

        self.axis(.vertical)
            .distribution(.fill)
            .alignment(.leading)
            .spacing(5)
            .contents(blocks)

        self.greaterThanOrEqualToSize(height: 10)
    }

    required init(coder: NSCoder) {
        fatalError()
    }

}