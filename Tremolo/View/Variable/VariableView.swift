//
//  VariableView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/13.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class VariableView: UIView {

    init(variable: Variable, types: [Type]) {
        super.init(frame: .zero)

        let hosting = UIHostingController(rootView: VariableView_SwiftUI(variable: .constant(variable)))
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

    init(variable: Binding<Variable>) {
        self._variable = variable
    }

    var body: some View {
        Button(action: {
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