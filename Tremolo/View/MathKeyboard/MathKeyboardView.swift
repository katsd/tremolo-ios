//
//  MathKeyboardView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/09.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MathKeyboardView: View {

    private enum keyValue {

        case text(texts: [String], cursor: Int)

        case action(() -> Void)

    }

    @ObservedObject var mathKeyboard = MathKeyboard()

    private let keySpacing: CGFloat = 3

    private let defaultKeySize = CGSize(width: 35, height: 40)

    private func keySize(width: Int, height: Int) -> CGSize {
        let w = (defaultKeySize.width + keySpacing) * CGFloat(width) - keySpacing
        let h = (defaultKeySize.width + keySpacing) * CGFloat(height) - keySpacing
        return .init(width: w, height: h)
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                VStack {
                    HStack {
                        self.leftKeys()
                        Spacer()
                        self.middleKeys()
                        Spacer()
                        self.rightKeys()
                    }
                        .padding(.horizontal, 20)

                    Spacer()
                        .frame(height: geo.safeAreaInsets.bottom)
                }
                    .edgesIgnoringSafeArea(.bottom)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity)
                    .background(Blur(style: .systemMaterial))
            }
        }
    }

    private func leftKeys() -> some View {
        VStack(spacing: keySpacing) {
            HStack(spacing: keySpacing) {
                simpleKey("6")
                simpleKey("7")
                simpleKey("8")
                simpleKey("9")
            }
            HStack(spacing: keySpacing) {
                simpleKey("2")
                simpleKey("3")
                simpleKey("4")
                simpleKey("5")
            }
            HStack(spacing: keySpacing) {
                simpleKey("0")
                simpleKey("1")
                simpleKey(".")
                simpleKey("=")
            }
        }
    }

    private func middleKeys() -> some View {
        VStack(spacing: keySpacing) {
            HStack(spacing: keySpacing) {
                simpleKey("*")
                simpleKey("/")
            }
            HStack(spacing: keySpacing) {
                simpleKey("+")
                simpleKey("-")
            }
            HStack(spacing: keySpacing) {
                simpleKey("(")
                simpleKey(")")
            }
        }
    }

    private func rightKeys() -> some View {
        VStack(spacing: keySpacing) {
            deleteKey()
            returnKey()
        }
    }

    private func keySpacer() -> some View {
        Spacer()
            .frame(width: defaultKeySize.width, height: defaultKeySize.height)
    }

    private func simpleKey(_ value: String) -> some View {
        keyView(value: .text(texts: [value], cursor: 0), size: defaultKeySize, labelColor: .black, color: .white) {
            Text(value)
        }
    }

    private func deleteKey() -> some View {
        keyView(value: .action({ MathKeyboard.receiver?.delete() }), size: defaultKeySize, labelColor: .white, color: .red) {
            Image(systemName: "delete.left.fill")
        }
    }

    private func returnKey() -> some View {
        keyView(value: .action({ MathKeyboard.receiver?.endEditing() }), size: keySize(width: 1, height: 2), labelColor: .white, color: .blue) {
            Image(systemName: "return")
        }
    }

    private func keyView<T: View>(value: keyValue, size: CGSize, labelColor: Color, color: Color, @ViewBuilder label: @escaping () -> T) -> some View {
        Button(action: {
            switch value {
            case let .text(texts:texts, cursor: cursor):
                MathKeyboard.receiver?.addTexts(texts, cursor: cursor)
            case let .action(action):
                action()
            }
        }) {
            label()
                .foregroundColor(labelColor)
                .frame(width: size.width, height: size.height)
        }
            .background(color)
            .cornerRadius(7)
    }

}
