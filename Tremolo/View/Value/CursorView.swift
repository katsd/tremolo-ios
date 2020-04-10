//
//  CursorView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/10.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class CursorView: UIView {

    init() {
        super.init(frame: .zero)

        size(width: 3, height: 20)
        backgroundColor(.systemBlue)
        cornerRadius(1)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

}
