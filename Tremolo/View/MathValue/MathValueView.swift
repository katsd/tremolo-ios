//
//  MathValueView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/09.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

final class MathValueView: UIView {

    private let tremolo: Tremolo

    private let stackView =
        UIStackView(frame: .zero)
            .axis(.horizontal)
            .distribution(.fill)
            .alignment(.center)

    private let cursor = CursorView()

    private let value: MathValue

    private let blockController: BlockController?

    @Binding var isEditable: Bool

    // 0   1   2   3  <- cursorPos
    // | A | B | C |
    private var cursorPos = 0

    private let blockViewPadding: CGFloat = 2

    init(tremolo: Tremolo, value: MathValue, blockController: BlockController?, isEditable: Binding<Bool>) {
        self.tremolo = tremolo

        self.value = value

        self.blockController = blockController

        self._isEditable = isEditable

        super.init(frame: .zero)

        greaterThanOrEqualToSize(width: 10, height: 25)

        value.contentStack.forEach { content in
            switch content {
            case let .raw(str):
                self.stackView.addArrangedSubview(label(str))
            case let .variable(variable):
                self.stackView.addArrangedSubview(variableLabel(variable))
            case let .block(block):
                self.stackView.addArrangedSubview(blockView(block))
            }
        }

        addSubview(stackView)
        stackView.equalTo(self, inset: .init(top: 4, left: 2, bottom: 4, right: 2))

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
        addSubview(cursor)
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
        BlockView(tremolo: tremolo, block: block, blockController: blockController)
    }

}

extension MathValueView: KeyboardReceiver {

    func delete() {
        if cursorPos == 0 {
            return
        }

        value.remove(at: cursorPos)

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
            value.insert(.raw(text), at: cursorPos + idx)
            stackView.insertArrangedSubview(label(text), at: cursorPos + idx)
        }

        layoutIfNeeded()

        cursorPos += cursor + 1
        moveCursorView(withAnimation: false)
    }

}

extension MathValueView: VariableKeyboardReceiver {

    func addVariable(_ variable: Variable) {
        value.insert(.variable(variable), at: cursorPos)

        stackView.insertArrangedSubview(variableLabel(variable), at: cursorPos)
        layoutIfNeeded()
        cursorPos += 1
        moveCursorView(withAnimation: false)
    }

}

extension MathValueView: BlockStackViewController {

    func addBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> (), completion: @escaping () -> ()) {
        value.insert(.block(blockView.block), at: idx)

        let holderView = MathValueHolderView(blockView: blockView, padding: blockViewPadding)

        CodeView.insertBlockView(stackView: stackView, blockView: holderView, at: idx, updateLayout: updateLayout, completion: completion)

        removeCursor()
    }

    func floatBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        value.remove(at: idx)
        stackView.arrangedSubviews[idx].removeFromSuperview()
        CodeView.updateLayoutWithAnimation(updateLayout: updateLayout)
    }

    func addBlankView(blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        cursorPos = idx
        moveCursorView(withAnimation: false)
        CodeView.updateLayoutWithAnimation(updateLayout: updateLayout)
    }

    func removeBlankView(path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        removeCursor()
        CodeView.updateLayoutWithAnimation(updateLayout: updateLayout)
    }

    func findBlockPos(blockView: BlockView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos? {
        let blockPos: CGPoint

        if velocity.y > 0 {
            blockPos = CGPoint(x: blockView.globalFrame.minX, y: blockView.globalFrame.maxY)
        } else {
            blockPos = CGPoint(x: blockView.globalFrame.minX, y: blockView.globalFrame.minY)
        }

        if !globalFrame.contains(blockPos) {
            return nil
        }

        var l = -1
        var r = stackView.arrangedSubviews.count

        while r - l > 1 {
            let mid = (r + l) / 2

            if stackView.arrangedSubviews[mid].globalFrame.minX < blockPos.x {
                l = mid
            } else {
                r = mid
            }
        }

        if l == -1 {
            return BlockPos(blockStackViewController: self, path: .zero, idx: 0)
        }

        if let blockHolderView = stackView.arrangedSubviews[l] as? MathValueHolderView {
            if blockHolderView.blockView != blockView {
                if let pos = blockHolderView.blockView.findBlockPos(blockView: blockView, velocity: velocity, selectedBlockPos: selectedBlockPos) {
                    return pos
                }
            }
        }

        if blockPos.x < stackView.arrangedSubviews[l].globalFrame.midX {
            return BlockPos(blockStackViewController: self, path: .zero, idx: l)
        } else {
            return BlockPos(blockStackViewController: self, path: .zero, idx: l + 1)
        }
    }

}

private class MathValueHolderView: UIView {

    let blockView: BlockView

    init(blockView: BlockView, padding: CGFloat) {
        self.blockView = blockView

        super.init(frame: .zero)

        let center = blockView.center
        blockView.superview?.addSubview(self)

        addSubview(blockView)

        blockView.equalToEach(self, top: 0, left: padding, bottom: 0, right: padding)

        frame.size = CGSize(width: blockView.frame.width + padding * 2, height: blockView.frame.height)
        self.center = center
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

}