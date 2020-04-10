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

    private let maxOpacity: Float = 1

    private let minOpacity: Float = 0.01

    init() {
        super.init(frame: .zero)

        size(width: 3, height: 20)
        backgroundColor(.systemBlue)
        cornerRadius(2)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func startAnimation() {
        timer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(animation), userInfo: nil, repeats: true)
    }

    func stopAnimation() {
        timer?.invalidate()
        timer = nil
        UIView.animate(withDuration: 0.1) {
            self.layer.opacity = self.maxOpacity
        }
    }

    func remove() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func animation() {
        UIView.animate(withDuration: 0.2) {
            if self.layer.opacity == self.maxOpacity {
                self.layer.opacity = self.minOpacity
            } else {
                self.layer.opacity = self.maxOpacity
            }
        }

    }


}
