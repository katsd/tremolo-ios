//
//  MathKeyboard.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/09.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class MathKeyboard {

    static var receiver: MathKeyboardReceiver? = nil

    static let observable = MathKeyboardObservable()

    static func openKeyboard() {
        animation {
            observable.showKeyboard = true
        }
    }

    static func closeKeyboard() {
        if !observable.showKeyboard {
            return
        }
        receiver?.endEditing()
        animation {
            observable.showKeyboard = false
        }
    }

    static func toggleKeyboard() {
        animation {
            observable.showKeyboard.toggle()
        }
    }

    private static func animation(_ action: () -> Void) {
        withAnimation(.easeInOut(duration: 0.2)) {
            action()
        }
    }

}

class MathKeyboardObservable: ObservableObject {

    @Published var showKeyboard = false

}
