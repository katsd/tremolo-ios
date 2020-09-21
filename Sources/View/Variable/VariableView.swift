//
//  VariableView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/13.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

final class VariableView: UIButton {

    private let tremolo: Tremolo

    @Binding private var isEditable: Bool

    private let variable: Variable

    init(tremolo: Tremolo, variable: Variable, types: [Type], isEditable: Binding<Bool>) {
        self.tremolo = tremolo

        self._isEditable = isEditable

        self.variable = variable

        super.init(frame: .zero)

        self.contentEdgeInsets(.init(top: 3, left: 3, bottom: 3, right: 3))
            .cornerRadius(5)
            .backgroundColor(.systemGray6)
        //.backgroundColor(UIColor.systemGray6.withAlphaComponent(0.5))

        setTitle(variable.name, for: .normal)
        setStyle()
        sizeToFit()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setStyle()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.5
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEnd()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEnd()
    }

    private func touchEnd() {
        if self.isEditable {
            Keyboard.open(keyboardReceiver: self,
                          variableKeyboardReceiver: self,
                          keyboardType: .variable,
                          variableType: variable.type,
                          availableVariables: getAvailableVariables(),
                          selectOneVariable: true)
        }

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }

    private func setStyle() {
        setTitleColor(.label, for: .normal)
    }


}

extension VariableView: VariableKeyboardReceiver {

    func addVariable(_ variable: Variable) {
        self.variable.copy(from: variable)
        setTitle(variable.name, for: .normal)
    }

}

extension VariableView: KeyboardReceiver {

    func delete() {
    }

    func endEditing() {
    }

    func moveCursor(_ direction: CursorDirection) {
    }

}

extension VariableView {

    func getAvailableVariables() -> [Variable] {
        if let block = variable.parentBlock {
            return tremolo.getVariables(above: block, type: variable.type)
        } else {
            return []
        }
    }

}
