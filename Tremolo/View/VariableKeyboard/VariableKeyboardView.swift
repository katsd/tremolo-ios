//
//  VariableKeyboardView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/13.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct VariableKeyboardView: View {

    @ObservedObject var observer = VariableKeyboard.observer

    var body: some View {
        Group {
            if self.observer.show {
                GeometryReader { geo in
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(0..<5, id: \.self) { _ in
                                Text("Yay")
                            }
                        }
                    }
                        .offset(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                    .frame(height: 100)
            }
        }
    }
}
