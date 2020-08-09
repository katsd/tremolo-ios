//
//  BlockStyle.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 8/9/20.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

struct BlockStyle {

    let color: UIColor

    let cornerRadius: CGFloat

    let shadow: BlockShadowStyle

    init(color: UIColor, cornerRadius: CGFloat = 10, shadow: BlockShadowStyle = .defaultStyle) {
        self.color = color
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }

}
