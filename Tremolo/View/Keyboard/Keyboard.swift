//
//  Keyboard.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/11.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

enum KeyboardType {

    case math

    case variable

}

class Keyboard {

    static var receiver: KeyboardReceiver?

    static var mathKeyboardReceiver: MathKeyboardReceiver?

    static var variableKeyboardReceiver: VariableKeyboardReceiver?

    static let observer = KeyboardObserver()

    static func open(keyboardReceiver: KeyboardReceiver,
                     mathKeyboardReceiver: MathKeyboardReceiver? = nil,
                     variableKeyboardReceiver: VariableKeyboardReceiver? = nil,
                     type: KeyboardType,
                     selectOneVariable: Bool = false) {

        releaseReceiver()

        receiver = keyboardReceiver

        self.mathKeyboardReceiver = mathKeyboardReceiver

        self.variableKeyboardReceiver = variableKeyboardReceiver

        if mathKeyboardReceiver == nil && variableKeyboardReceiver == nil {
            return
        }

        if type == .math && mathKeyboardReceiver != nil {
            observer.type = .math
        } else {
            observer.type = .variable
        }

        if selectOneVariable {
            observer.enableControlKeys = false
            observer.selectOneVariable = true
        } else {
            observer.enableControlKeys = true
            observer.selectOneVariable = false
        }

        animation {
            observer.show = true
        }
    }

    static func closeKeyboard() {
        releaseReceiver()
        animation {
            observer.show = false
        }
    }

    static private func releaseReceiver() {
        receiver?.endEditing()
        receiver = nil
        mathKeyboardReceiver = nil
        variableKeyboardReceiver = nil
    }

    private static func animation(_ action: () -> Void) {
        withAnimation(.easeInOut(duration: 0.2)) {
            action()
        }
    }

}

class KeyboardObserver: ObservableObject {

    @Published var show = false

    @Published var type: KeyboardType = .math

    @Published var enableControlKeys = true

    @Published var selectOneVariable = false

    @Published var variableTypes: [Type] = [.custom("value")]

}
