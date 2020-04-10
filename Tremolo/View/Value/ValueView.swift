//
//  ValueView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/09.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class ValueView: UIView {

    let stackView = UIStackView(frame: .zero)

    init(value: Value) {
        super.init(frame: .zero)

        "1+2*3".forEach {
            let label = UILabel()
                .text(String($0))
                .textColor(.black)

            self.stackView.addArrangedSubview(label)
        }

        addSubview(stackView)
        stackView.equalTo(self, inset: .init(top: 3, left: 3, bottom: 3, right: 3))

        setStyle()

        setGesture()

        MathKeyboard.receiver = self
    }

    required init(coder: NSCoder) {
        fatalError()
    }

    private func setStyle() {
        self.backgroundColor(.white)
            .cornerRadius(5)
    }

    private func setGesture() {
        self.isUserInteractionEnabled = true

        self.tap { _ in
            MathKeyboard.openKeyboard()
        }
    }
}

extension ValueView: MathKeyboardReceiver {

    func addTexts(_ texts: [String], cursor: Int) {
        print(texts)
    }

    func delete() {
        print("Delete")
    }

    func endEditing() {
        print("Return")
    }

    func moveCursor(_ direction: CursorDirection) {
        print("Move")
    }

}
