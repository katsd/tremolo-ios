//
//  UIView+Constraint.swift
//  Example
//  
//  Created by Katsu Matsuda on 2020/03/29.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

extension UIView {

    func equalTo(_ view: UIView, inset: UIEdgeInsets = .zero) {
        guard let _ = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                self.topAnchor.constraint(equalTo: view.topAnchor, constant: inset.top),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset.bottom),
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset.left),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset.right),
            ]
        )
    }

    func equalToCenter(_ view: UIView, x: Bool = true, y: Bool = true) {
        guard  let _ = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        if x {
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }

        if y {
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }

    func equalToSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        guard  let _ = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

}
