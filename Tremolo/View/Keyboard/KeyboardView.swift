//
//  KeyboardView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/11.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct KeyboardView: View {

    @ObservedObject var observer = Keyboard.observer

    private let safeAreaInsets: EdgeInsets

    init(safeAreaInsets: EdgeInsets) {
        self.safeAreaInsets = safeAreaInsets
    }

    var body: some View {
        Group {
            if observer.show {
                VStack(spacing: 0) {
                    if observer.type == .math {
                        MathKeyboardView()
                    } else {
                        VariableKeyboardView()
                    }

                    Spacer()
                        .frame(height: safeAreaInsets.bottom)
                }
                    .edgesIgnoringSafeArea(.bottom)
                    .background(Blur(style: .systemMaterial))
                    .transition(.move(edge: .bottom))
            }
        }
    }

}
