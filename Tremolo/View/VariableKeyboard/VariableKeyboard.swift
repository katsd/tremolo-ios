//
//  VariableKeyboard.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/13.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class VariableKeyboard {

    static var receiver: VariableKeyboardReceiver? = nil

    static let observer = VariableKeyboardObserver()

    static func setReceiver(_ receiver: VariableKeyboardReceiver) {
        self.receiver = receiver
    }

    static func open() {
        observer.show = true
    }

    static func close() {
        observer.show = false
    }

    static func show(frame: CGRect) {
        observer.variableViewFrame = frame
        observer.show = true
    }

    static func hide() {
        observer.show = false
    }

}

class VariableKeyboardObserver: ObservableObject {

    @Published var variableViewFrame = CGRect()

    @Published var show = false

}
