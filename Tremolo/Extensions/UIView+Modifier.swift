//
//  UIView+Modifier.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/29.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

extension UIView {

    func size(width: CGFloat, height: CGFloat) -> UIView {
        self.frame.size = CGSize(width: width, height: height)
        return self
    }

    func backgroundColor(_ color: UIColor) -> UIView {
        self.backgroundColor = color
        return self
    }

    func cornerRadius(_ radius: CGFloat) -> UIView {
        self.layer.cornerRadius = radius
        return self
    }

}
