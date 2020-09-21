//
//  UIColor+DynamicColor.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/24.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

extension UIColor {

    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { traitCollection -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            } else {
                return light
            }
        }
    }

}
