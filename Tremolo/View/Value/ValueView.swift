//
//  ValueView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/09.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class ValueView: UIView {

    private let stackView = UIStackView(frame: .zero)

    private let cursor = CursorView()

    // 0   1   2   3  <- cursorPos
    // | A | B | C |
    private var cursorPos = 0

    init(value: Value) {
        super.init(frame: .zero)

        "1+2*3".forEach {
            self.stackView.addArrangedSubview(label(String($0)))
        }

        addSubview(stackView)
        stackView.equalTo(self, inset: .init(top: 3, left: 3, bottom: 3, right: 3))

        setStyle()

        setGesture()
    }

    required init(coder: NSCoder) {
        fatalError()
    }

    private func setStyle() {
        backgroundColor(.white)
        cornerRadius(5)
    }

    private func setGesture() {
        isUserInteractionEnabled = true

        tap { gesture in
            MathKeyboard.setReceiver(self)
            MathKeyboard.openKeyboard()
            self.addCursor(tapLocation: gesture.location(in: nil))
        }

        cursor.drag { gesture in
            switch gesture.state {
            case .began:
                self.cursor.stopAnimation()
            case .ended:
                self.addCursor(tapLocation: self.cursor.globalFrame.center, withAnimation: true)
                return
            default:
                break
            }

            let nextFrame = CGRect(origin: .init(x: self.cursor.frame.origin.x + gesture.translation(in: nil).x,
                                                 y: self.cursor.frame.origin.y + gesture.translation(in: nil).y),
                                   size: self.cursor.frame.size)

            gesture.setTranslation(.zero, in: nil)

            if !self.frame.contains(nextFrame) {
                return
            }

            self.cursor.frame = nextFrame
        }
    }

    private func addCursor(tapLocation: CGPoint, withAnimation: Bool = false) {
        addSubview(cursor)
        cursor.startAnimation()

        if stackView.arrangedSubviews.count == 0 {
            cursorPos = 0
            moveCursorView(withAnimation: false)
            return
        }

        var l = -1
        var r = stackView.arrangedSubviews.count
        while r - l > 1 {
            let mid = (r + l) / 2
            if tapLocation.x <= stackView.arrangedSubviews[mid].globalFrame.maxX {
                r = mid
            } else {
                l = mid
            }
        }

        if r == stackView.arrangedSubviews.count {
            cursorPos = stackView.arrangedSubviews.count
            moveCursorView(withAnimation: false)
            return
        }

        let leftDis = abs(stackView.arrangedSubviews[r].globalFrame.minX - tapLocation.x)
        let rightDis = abs(stackView.arrangedSubviews[r].globalFrame.maxX - tapLocation.x)

        if leftDis < rightDis {
            cursorPos = r
        } else {
            cursorPos = r + 1
        }

        moveCursorView(withAnimation: withAnimation)
    }

    private func removeCursor() {
        cursor.remove()
        cursor.removeFromSuperview()
    }

    private func moveCursorView(withAnimation: Bool) {
        cursor.stopAnimation()

        let posX: CGFloat
        if stackView.arrangedSubviews.count == 0 {
            posX = center.x
        } else {
            if cursorPos == 0 {
                posX = stackView.arrangedSubviews[0].convertFrame(parent: self).minX
            } else {
                posX = stackView.arrangedSubviews[cursorPos - 1].convertFrame(parent: self).maxX
            }
        }

        if withAnimation {
            UIView.animate(withDuration: 0.2, animations: {
                self.cursor.center.x = posX
                self.cursor.center.y = self.center.y
            }, completion: { _ in
                self.cursor.startAnimation()
            })
        } else {
            cursor.center.x = posX
            cursor.center.y = center.y
            cursor.startAnimation()
        }
    }

    private func label(_ text: String) -> UILabel {
        UILabel()
            .text(text)
            .textColor(.black)
    }
}

extension ValueView: MathKeyboardReceiver {

    func addTexts(_ texts: [String], cursor: Int) {
        for (idx, text) in texts.enumerated() {
            stackView.insertArrangedSubview(label(text), at: cursorPos + idx)
        }

        layoutIfNeeded()

        cursorPos += cursor + 1
        moveCursorView(withAnimation: false)
    }

    func delete() {
        if cursorPos == 0 {
            return
        }

        stackView.arrangedSubviews[cursorPos - 1].removeFromSuperview()

        layoutIfNeeded()

        cursorPos -= 1
        moveCursorView(withAnimation: false)
    }

    func endEditing() {
        removeCursor()
    }

    func moveCursor(_ direction: CursorDirection) {
        let nextPos = cursorPos + direction.rawValue

        if nextPos < 0 || stackView.arrangedSubviews.count < nextPos {
            return
        }

        cursorPos = nextPos
        moveCursorView(withAnimation: true)
    }

}
