//
//  BlockStyle.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 8/9/20.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

public struct BlockStyle {

    let color: UIColor

    let cornerRadius: CGFloat

    let shadow: BlockShadowStyle

    public init(color: UIColor, cornerRadius: CGFloat = 10, shadow: BlockShadowStyle = .defaultStyle) {
        self.color = color
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }

    public static var defaultStyle: BlockStyle {
        BlockStyle(color:
                   UIColor.dynamicColor(light: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
                                        dark: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1))
        )
    }

}
