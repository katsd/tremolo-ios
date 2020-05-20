//
//  VariableKeyboardView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/13.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct VariableKeyboardView: View {

    @EnvironmentObject var tremolo: Tremolo

    @Binding var variableTypes: [Type]

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 10) {
                variableButtons()
            }
        }
    }

    private func variableButtons() -> some View {
        ForEach(tremolo.variables, id: \.self) { (variable: Variable) in
            Group {
                if self.variableTypes.contains(variable.type) {
                    Button(action: {
                        Keyboard.variableKeyboardReceiver?.addVariable(variable)
                    }) {
                        HStack {
                            Text(variable.name)
                            Spacer()
                        }
                    }
                        .foregroundColor(.primary)
                }
            }
        }
    }

}
