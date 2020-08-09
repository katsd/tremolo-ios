//
//  StringValueView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 8/9/20.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

final class StringValueView: UITextField, UITextFieldDelegate {

    let value: StringValue

    init(value: StringValue, textColor: UIColor) {
        self.value = value

        super.init(frame: .zero)

        self.text = value.string

        self.textColor = textColor

        self.delegate = self

        self.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        value.string = textField.text ?? ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

