//
//  VariableView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/13.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class VariableView: UIView {

    @Binding private var isEditable: Bool

    init(variable: Variable, types: [Type], isEditable: Binding<Bool>) {

        self._isEditable = isEditable

        super.init(frame: .zero)

        let hosting = UIHostingController(rootView: VariableView_SwiftUI(variable: .constant(variable), isEditable: isEditable))
        hosting.view.backgroundColor = .clear

        addSubview(hosting.view)
        hosting.view.equalTo(self)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

}

private struct VariableView_SwiftUI: View {

    @Binding private var variable: Variable

    @Binding private var isEditable: Bool

    init(variable: Binding<Variable>, isEditable: Binding<Bool>) {
        self._variable = variable

        self._isEditable = isEditable
    }

    var body: some View {
        Button(action: {
            if !self.isEditable {
                return
            }
            print("Select Variable")
        }) {
            Text(variable.name)
                .foregroundColor(.black)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(Color.white.opacity(0.5))
                .cornerRadius(5)
        }
    }
}