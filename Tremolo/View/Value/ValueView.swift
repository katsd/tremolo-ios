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
    }

    private func addCursor(tapLocation: CGPoint) {
        addSubview(cursor)
        cursor.show()

        cursor.center.y = center.y

        if stackView.arrangedSubviews.count == 0 {
            cursor.center.x = center.x
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
            cursor.center.x = stackView.arrangedSubviews[stackView.arrangedSubviews.count - 1].convertFrame(parent: self).maxX
            cursorPos = stackView.arrangedSubviews.count
            return
        }

        let leftDis = abs(stackView.arrangedSubviews[r].globalFrame.minX - tapLocation.x)
        let rightDis = abs(stackView.arrangedSubviews[r].globalFrame.maxX - tapLocation.x)

        if leftDis < rightDis {
            cursor.center.x = stackView.arrangedSubviews[r].convertFrame(parent: self).minX
            cursorPos = r
        } else {
            cursor.center.x = stackView.arrangedSubviews[r].convertFrame(parent: self).maxX
            cursorPos = r + 1
        }
    }

    private func removeCursor() {
        cursor.remove()
        cursor.removeFromSuperview()
    }

    private func moveCursorView(withAnimation: Bool) {
        let nextPosX: CGFloat
        if stackView.arrangedSubviews.count == 0 {
            nextPosX = center.x
        } else {
            if cursorPos == 0 {
                nextPosX = stackView.arrangedSubviews[0].convertFrame(parent: self).minX
            } else {
                nextPosX = stackView.arrangedSubviews[cursorPos].convertFrame(parent: self).maxX
            }
        }

        if withAnimation {
            UIView.animate(withDuration: 0.2) {
                self.cursor.center.x = nextPosX
            }
        } else {
            cursor.center.x = nextPosX

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
        print("Delete")
    }

    func endEditing() {
        removeCursor()
    }

    func moveCursor(_ direction: CursorDirection) {
        let nextPos = cursorPos + direction.rawValue

        if nextPos < 0 || stackView.arrangedSubviews.count <= nextPos {
            return
        }

        cursorPos = nextPos
        moveCursorView(withAnimation: true)
    }

}
