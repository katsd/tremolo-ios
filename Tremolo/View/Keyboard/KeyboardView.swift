//
//  KeyboardView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/11.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct KeyboardView: View {

    @EnvironmentObject var tremolo: Tremolo

    @ObservedObject var observer = Keyboard.observer

    private let safeAreaInsets: EdgeInsets

    @State var keyboardType: KeyboardType = .math

    init(safeAreaInsets: EdgeInsets) {
        self.safeAreaInsets = safeAreaInsets
    }

    var body: some View {
        Group {
            if observer.show {
                VStack(spacing: 0) {
                    topButtons()
                    keysView()
                    Spacer()
                        .frame(height: safeAreaInsets.bottom)
                }
                    .padding(.horizontal, 10)
                    .background(Blur(style: .systemThinMaterial).background(Color.black.opacity(0.2)))
                    .transition(.move(edge: .bottom))
            }
        }
    }

    private func topButtons() -> some View {
        HStack {
            Group {
                keyboardTypePicker()

                Spacer()

                Button(action: { Keyboard.closeKeyboard() }) {
                    Image(systemName: "keyboard.chevron.compact.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical, 14)
                }
            }
        }
            .foregroundColor(.primary)
            .frame(height: 50)
    }

    private func keyboardTypePicker() -> some View {
        Picker(selection: $observer.type, label: EmptyView()) {
            Image(systemName: "textformat.123").tag(KeyboardType.math)
            Image(systemName: "xmark").tag(KeyboardType.variable)
        }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 120)
            .disabled(observer.selectOneVariable)

    }

    private func keysView() -> some View {
        HStack(alignment: .bottom) {
            Group {
                if observer.type == .math {
                    MathKeyboardView()
                } else {
                    VariableKeyboardView(variableTypes: $observer.variableTypes)
                        .environmentObject(tremolo)
                }
            }
                .frame(maxWidth: .infinity)

            VStack(spacing: KeySize.spacing) {
                HStack(spacing: KeySize.spacing) {
                    directionKey(direction: .back)
                    directionKey(direction: .forward)
                }
                deleteKey()
                returnKey()
            }
                .disabled(!observer.enableControlKeys)
                .opacity(controlKeysOpacity)
        }
            .padding(.bottom, 5)
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
                .foregroundColor(.primary)
        }
    }

    private var controlKeysOpacity: Double {
        observer.enableControlKeys ? 1 : 0.5
    }

}
