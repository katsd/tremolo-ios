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

    @State var type: Type = .custom("value")

    @State var variables: [Variable]

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    variableButtons()
                }
            }
            addVariableButton()
                .padding(.trailing, 30)
        }
    }

    private func variableButtons() -> some View {
        ForEach(variables, id: \.self) { (variable: Variable) in
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

    private func addVariableButton() -> some View {
        Button(action: {
            self.inputNewVariable()
        }) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 3)
                .overlay(
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Variable")
                    }
                        .font(Font.body.weight(.medium))
                )
        }
            .frame(height: 30)

    }

    private func inputNewVariable() {
        let ac = UIAlertController(title: "New Variable", message: "Enter a name for this variable.", preferredStyle: .alert)

        let add = UIAlertAction(title: "Add", style: .default) { _ in
            self.variables.append(Variable(type: self.type, name: ac.textFields?.first?.text ?? ""))
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        ac.addTextField()
        ac.addAction(cancel)
        ac.addAction(add)

        ac.textFields?.first?.placeholder = "Variable Name"

        UIApplication.shared.windows.first?.rootViewController?.present(ac, animated: true)
    }

}
