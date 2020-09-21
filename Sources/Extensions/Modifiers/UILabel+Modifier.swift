//
//  UILabel+Modifier.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/29.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

extension UILabel {

    func text(_ text: String) -> UILabel {
        self.text = text
        return self
    }

    func textColor(_ color: UIColor) -> UILabel {
        self.textColor = color
        return self
    }

}
