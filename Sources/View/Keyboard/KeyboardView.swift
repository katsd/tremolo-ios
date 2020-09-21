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

    var body: some View {
        GeometryReader { geo in
            if observer.show {
                VStack(spacing: 0) {
                    Color.clear
                    VStack(spacing: 0) {
                        topButtons()
                        keysView()
                        Spacer()
                            .frame(height: geo.safeAreaInsets.bottom)
                    }
                        .padding(.horizontal, 10)
                        .background(Blur(style: .systemThinMaterial)
                                        .background(Color.black.opacity(0.2))
                        )
                }
                    .transition(.move(edge: .bottom))
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }

    private func topButtons() -> some View {
        HStack {
            Group {
                KeyboardTypePicker(type: $observer.keyboardType, disabled: $observer.selectOneVariable)
                    .equatable()

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

    private func keysView() -> some View {
        HStack(alignment: .bottom) {
            Group {
                if observer.keyboardType == .math {
                    MathKeyboardView()
                } else {
                    VariableKeyboardView(type: $observer.variableType, variables: observer.availableVariables)
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

private struct KeyboardTypePicker: View, Equatable {

    @Binding var type: KeyboardType

    @Binding var disabled: Bool

    var body: some View {
        Picker(selection: $type, label: EmptyView()) {
            Image(systemName: "textformat.123").tag(KeyboardType.math)
            Image(systemName: "xmark").tag(KeyboardType.variable)
        }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 120)
            .disabled(disabled)
    }

    static func ==(lhs: KeyboardTypePicker, rhs: KeyboardTypePicker) -> Bool {
        lhs.type == rhs.type &&
            lhs.disabled == rhs.disabled
    }
}