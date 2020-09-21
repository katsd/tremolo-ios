//
//  UIView+Constraint.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/29.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

extension UIView {

    func equalTo(_ view: UIView, inset: UIEdgeInsets = .zero, priority: Float = 1000) {
        guard let _ = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                self.topAnchor.constraint(equalTo: view.topAnchor, constant: inset.top).priority(priority),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset.bottom).priority(priority),
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset.left).priority(priority),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset.right).priority(priority),
            ]
        )
    }

    func equalToEach(_ view: UIView, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, priority: Float = 1000) {
        guard  let _ = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top).priority(priority).isActive = true
        }

        if let left = left {
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: left).priority(priority).isActive = true
        }

        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom).priority(priority).isActive = true
        }

        if let right = right {
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -right).priority(priority).isActive = true
        }
    }

    func lessThanOrEqualTo(_ view: UIView, maxInset: UIEdgeInsets = .zero, priority: Float = 1000) {
        guard let _ = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                self.topAnchor.constraint(lessThanOrEqualTo: self.topAnchor, constant: maxInset.top).priority(priority),
                self.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: -maxInset.bottom).priority(priority),
                self.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor, constant: maxInset.left).priority(priority),
                self.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -maxInset.right).priority(priority),
            ]
        )
    }

    func lessThanOrEqualToEach(_ view: UIView, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, priority: Float = 1000) {
        guard  let _ = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            self.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: top).priority(priority).isActive = true
        }

        if let left = left {
            self.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor, constant: left).priority(priority).isActive = true
        }

        if let bottom = bottom {
            self.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -bottom).priority(priority).isActive = true
        }

        if let right = right {
            self.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -right).priority(priority).isActive = true
        }
    }

    func equalToCenter(_ view: UIView, x: Bool = true, y: Bool = true, priority: Float = 1000) {
        guard  let _ = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        if x {
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).priority(priority).isActive = true
        }

        if y {
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).priority(priority).isActive = true
        }
    }

    func equalToSize(width: CGFloat? = nil, height: CGFloat? = nil, priority: Float = 1000) {
        self.translatesAutoresizingMaskIntoConstraints = false

        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).priority(priority).isActive = true
        }

        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).priority(priority).isActive = true
        }
    }

    func lessThanOrEqualToSize(width: CGFloat? = nil, height: CGFloat? = nil, priority: Float = 1000) {
        self.translatesAutoresizingMaskIntoConstraints = false

        if let width = width {
            self.widthAnchor.constraint(lessThanOrEqualToConstant: width).priority(priority).isActive = true
        }

        if let height = height {
            self.heightAnchor.constraint(lessThanOrEqualToConstant: height).priority(priority).isActive = true
        }
    }

    func greaterThanOrEqualToSize(width: CGFloat? = nil, height: CGFloat? = nil, priority: Float = 1000) {
        self.translatesAutoresizingMaskIntoConstraints = false

        if let width = width {
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: width).priority(priority).isActive = true
        }

        if let height = height {
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: height).priority(priority).isActive = true
        }
    }

    func equalToSizeOf(_ view: UIView, priority: Float = 1000) {
        guard let _ = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        self.widthAnchor.constraint(equalTo: view.widthAnchor).priority(priority).isActive = true
        self.heightAnchor.constraint(equalTo: view.heightAnchor).priority(priority).isActive = true
    }

}

extension NSLayoutConstraint {

    func priority(_ p: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(max(0, min(1000, p)))
        return self
    }

}