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

    private let keySpacing: CGFloat = 5

    private let defaultKeySize = CGSize(width: 35, height: 40)

    private func keySize(width: Int, height: Int) -> CGSize {
        let w = (defaultKeySize.width + keySpacing) * CGFloat(width) - keySpacing
        let h = (defaultKeySize.height + keySpacing) * CGFloat(height) - keySpacing
        return .init(width: w, height: h)
    }

    var body: some View {
        HStack {
            leftKeys()
            Spacer()
            middleKeys()
        }
    }

    private func leftKeys() -> some View {
        VStack(spacing: keySpacing) {
            HStack(spacing: keySpacing) {
                keyView("6")
                keyView("7")
                keyView("8")
                keyView("9")
            }
            HStack(spacing: keySpacing) {
                keyView("2")
                keyView("3")
                keyView("4")
                keyView("5")
            }
            HStack(spacing: keySpacing) {
                keyView("0")
                keyView("1")
                keyView(".")
                keyView("=")
            }
        }
    }

    private func middleKeys() -> some View {
        VStack(spacing: keySpacing) {
            HStack(spacing: keySpacing) {
                keyView("*")
                keyView("/")
            }
            HStack(spacing: keySpacing) {
                keyView("+")
                keyView("-")
            }
            HStack(spacing: keySpacing) {
                keyView("(")
                keyView(")")
            }
        }
    }

    private func keyView(_ value: String) -> some View {
        KeyView(value: .text(texts: [value], cursor: 0)) {
            Text(value)
                .foregroundColor(.primary)
        }
    }
}
