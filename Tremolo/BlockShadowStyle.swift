//
//  BlockShadowStyle.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 8/9/20.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

struct BlockShadowStyle {

    let color: UIColor

    let opacity: CGFloat

    let radius: CGFloat

    let offset: CGSize

    static var defaultStyle: BlockShadowStyle {
        BlockShadowStyle(color: .black, opacity: 0.15, radius: 5, offset: CGSize(width: 0, height: 3))
    }

    static var none: BlockShadowStyle {
        BlockShadowStyle(color: .black, opacity: 0, radius: 0, offset: .zero)
    }

}
