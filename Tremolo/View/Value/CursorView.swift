//
//  CursorView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/10.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class CursorView: UIView {

    private var timer: Timer? = nil

    private let visibleView: UIView

    private let maxAlpha: CGFloat = 1

    private let minAlpha: CGFloat = 0.02

    let cursorSize = CGSize(width: 3, height: 20)

    init() {
        visibleView = UIView()
            .size(cursorSize)
            .backgroundColor(.systemBlue)
            .cornerRadius(2)

        super.init(frame: .zero)

        size(width: cursorSize.width * 7, height: cursorSize.height)
        backgroundColor(.init(white: 0, alpha: 0.02))

        visibleView.center = center
        addSubview(visibleView)
        visibleView.alpha = 1
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func startAnimation() {
        timer?.invalidate()
        timer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(animation), userInfo: nil, repeats: true)
    }

    func stopAnimation() {
        timer?.invalidate()
        UIView.animate(withDuration: 0.1) {
            self.visibleView.alpha = self.maxAlpha
        }
    }

    func remove() {
        timer?.invalidate()
    }

    @objc private func animation() {
        UIView.animate(withDuration: 0.2) {
            if self.visibleView.alpha == self.maxAlpha {
                self.visibleView.alpha = self.minAlpha
            } else {
                self.visibleView.alpha = self.maxAlpha
            }
        }
    }

}
