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
                     keyboardType: KeyboardType,
                     variableType: Type,
                     availableVariables: [Variable],
                     selectOneVariable: Bool = false) {

        releaseReceiver()

        receiver = keyboardReceiver

        self.mathKeyboardReceiver = mathKeyboardReceiver

        self.variableKeyboardReceiver = variableKeyboardReceiver

        if mathKeyboardReceiver == nil && variableKeyboardReceiver == nil {
            return
        }

        if keyboardType == .math && mathKeyboardReceiver != nil {
            observer.keyboardType = .math
        } else {
            observer.keyboardType = .variable
        }

        if selectOneVariable {
            observer.enableControlKeys = false
            observer.selectOneVariable = true
        } else {
            observer.enableControlKeys = true
            observer.selectOneVariable = false
        }

        observer.variableType = variableType
        observer.availableVariables = availableVariables

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

    @Published var keyboardType: KeyboardType = .math

    @Published var enableControlKeys = true

    @Published var selectOneVariable = false

    @Published var variableType = Type.void

    @Published var availableVariables = [Variable]()

}
