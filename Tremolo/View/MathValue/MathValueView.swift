//
//  MathValueView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/09.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class MathValueView: UIView {

    private let tremolo: Tremolo

    private let stackView = UIStackView(frame: .zero)

    private let cursor = CursorView()

    private let value: MathValue

    @Binding var isEditable: Bool

    // 0   1   2   3  <- cursorPos
    // | A | B | C |
    private var cursorPos = 0

    init(tremolo: Tremolo, value: MathValue, isEditable: Binding<Bool>) {
        self.tremolo = tremolo

        self.value = value

        self._isEditable = isEditable

        super.init(frame: .zero)

        greaterThanOrEqualToSize(width: 10, height: 25)

        value.value.forEach { content in
            switch content {
            case let .raw(str):
                str.forEach { char in
                    self.stackView.addArrangedSubview(label(String(char)))
                }
            case let .variable(variable):
                self.stackView.addArrangedSubview(variableLabel(variable))
            case let .block(block):
                self.stackView.addArrangedSubview(blockView(block))
            }
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
            if !self.isEditable {
                return
            }
            Keyboard.open(keyboardReceiver: self, mathKeyboardReceiver: self, variableKeyboardReceiver: self, type: .math)
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

            if 0 <= nextFrame.center.x - self.cursor.cursorSize.width / 2 &&
                   nextFrame.center.x + self.cursor.cursorSize.width / 2 <= self.frame.width {
                self.cursor.frame.origin.x = nextFrame.origin.x
            }

            if 0 <= nextFrame.minY && nextFrame.maxY <= self.frame.height {
                self.cursor.frame.origin.y = nextFrame.origin.y
            }
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
            posX = frame.width / 2
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
                self.cursor.center.y = self.frame.height / 2
            }, completion: { _ in
                self.cursor.startAnimation()
            })
        } else {
            cursor.center.x = posX
            cursor.center.y = frame.height / 2
            cursor.startAnimation()
        }
    }

    private func label(_ text: String) -> UILabel {
        UILabel()
            .text(text)
            .textColor(.black)
    }

    private func variableLabel(_ variable: Variable) -> UILabel {
        UILabel()
            .text(variable.name)
            .textColor(.red)
    }

    private func blockView(_ block: Block) -> BlockView {
        BlockView(tremolo: tremolo, block: block)
    }

}

extension MathValueView: KeyboardReceiver {

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

extension MathValueView: MathKeyboardReceiver {

    func addTexts(_ texts: [String], cursor: Int) {
        for (idx, text) in texts.enumerated() {
            stackView.insertArrangedSubview(label(text), at: cursorPos + idx)
        }

        layoutIfNeeded()

        cursorPos += cursor + 1
        moveCursorView(withAnimation: false)
    }

}

extension MathValueView: VariableKeyboardReceiver {

    func addVariable(_ variable: Variable) {
        stackView.insertArrangedSubview(variableLabel(variable), at: cursorPos)
        layoutIfNeeded()
        cursorPos += 1
        moveCursorView(withAnimation: false)
    }

}
