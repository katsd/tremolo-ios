//
//  KeyView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/19.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct KeyView<Content: View>: View {

    let value: KeyValue

    let size: CGSize

    let color: Color

    let label: () -> Content

    init(value: KeyValue, size: CGSize = KeySize.one.cgSize, color: Color = .gray, @ViewBuilder label: @escaping () -> Content) {
        self.value = value
        self.size = size
        self.color = color
        self.label = label
    }

    var body: some View {
        Button(action: {
            switch self.value {
            case let .text(texts: texts, cursor: cursor):
                Keyboard.mathKeyboardReceiver?.addTexts(texts, cursor: cursor)
            case let .action(action):
                action()
            }
        }) {
            label()
        }
            .frame(width: size.width, height: size.height)
            .background(color)
            .cornerRadius(7)
    }

}
