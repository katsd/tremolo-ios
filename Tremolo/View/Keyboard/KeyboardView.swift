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
                    keysView()
                    Spacer()
                        .frame(height: safeAreaInsets.bottom)
                }
                    .edgesIgnoringSafeArea(.bottom)
                    .background(Blur(style: .systemMaterial))
                    .transition(.move(edge: .bottom))
            }
        }
    }

    private func keysView() -> some View {
        HStack {
            if observer.type == .math {
                MathKeyboardView()
            } else {
                VariableKeyboardView()
            }

            VStack(spacing: KeySize.spacing) {
                HStack(spacing: KeySize.spacing) {
                    directionKey(direction: .back)
                    directionKey(direction: .forward)
                }
                deleteKey()
                returnKey()
            }
        }
    }

    private func deleteKey() -> some View {
        KeyView(value: .action({ Keyboard.receiver?.delete() }), size: KeySize(width: 2, height: 1).cgSize, color: .red) {
            Image(systemName: "delete.left.fill")
                .foregroundColor(.white)
        }
    }

    private func returnKey() -> some View {
        KeyView(value: .action({ Keyboard.closeKeyboard() }), size: KeySize(width: 2, height: 1).cgSize, color: .blue) {
            Image(systemName: "return")
                .foregroundColor(.white)
        }
    }

    private func directionKey(direction: CursorDirection) -> some View {
        let label: Image
        switch direction {
        case .forward:
            label = Image(systemName: "arrowtriangle.right.fill")
        case .back:
            label = Image(systemName: "arrowtriangle.left.fill")
        }

        return KeyView(value: .action({ Keyboard.receiver?.moveCursor(direction) })) {
            label
                .foregroundColor(.white)
        }
    }


}
