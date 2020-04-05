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
        frame.size = CGSize(width: width, height: height)
        return self
    }

    func backgroundColor(_ color: UIColor) -> UIView {
        backgroundColor = color
        return self
    }

    func cornerRadius(_ radius: CGFloat) -> UIView {
        layer.cornerRadius = radius
        return self
    }

    func shadow(color: UIColor = .black, opacity: Float = 1, radius: CGFloat = 3.0, offset: CGSize = .zero) -> UIView {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        return self
    }

    func clipsToBounds(_ flag: Bool) -> UIView {
        self.clipsToBounds = flag
        return  self
    }

}
